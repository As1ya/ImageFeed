//
//  ProfileImageService.swift
//  Image Feed
//
//  Created by Анастасия Федотова on 23.03.2026.
//

import Foundation

// MARK: - UserResult
struct UserResult: Codable {
    let profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}

final class ProfileImageService {
    
    // MARK: - Properties
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private init() {}
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastUsername: String?
    
    private(set) var avatarURL: String?
    
    // MARK: - Private Methods
    
    private func makeImageRequest(username: String, token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    // MARK: - Public Methods
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastUsername == username { return }
        task?.cancel()
        lastUsername = username
        
        guard let token = OAuth2TokenStorage().token else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        guard let request = makeImageRequest(username: username, token: token) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                self?.task = nil
                self?.lastUsername = nil
                
                switch result {
                case .success(let userResult):
                    if let avatarURL = userResult.profileImage?.large {
                        self?.avatarURL = avatarURL
                        completion(.success(avatarURL))
                        
                        NotificationCenter.default.post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": avatarURL]
                        )
                    } else {
                        print("[ProfileImageService]: fetchProfileImageURL - missing small avatar URL")
                        completion(.failure(NetworkError.invalidRequest))
                    }
                case .failure(let error):
                    print("[ProfileImageService]: fetchProfileImageURL - \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
        self.task = task
    }
}

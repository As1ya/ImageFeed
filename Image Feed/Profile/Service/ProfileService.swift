//
//  ProfileService.swift
//  Image Feed
//
//  Created by Анастасия Федотова on 23.03.2026.
//

import Foundation

final class ProfileService {
    
    // MARK: - Properties
    
    static let shared = ProfileService()
    private init() {}
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    private(set) var profile: Profile?
    
    // MARK: - Private Methods
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    // MARK: - Public Methods
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        
        guard let request = makeProfileRequest(token: token) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        var task: URLSessionTask?
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self, self.task === task else { return }
            self.task = nil
            self.lastToken = nil
            
            switch result {
            case .success(let profileResult):
                let firstName = profileResult.first_name ?? ""
                let lastName = profileResult.last_name ?? ""
                let name = [firstName, lastName].filter { !$0.isEmpty }.joined(separator: " ")
                let loginName = "@\(profileResult.username)"
                
                let profile = Profile(
                    username: profileResult.username,
                    name: name,
                    loginName: loginName,
                    bio: profileResult.bio
                )
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                print("[ProfileService]: fetchProfile - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        self.task = task
    }
    
    func clean() {
        profile = nil
        task?.cancel()
        task = nil
        lastToken = nil
    }
}

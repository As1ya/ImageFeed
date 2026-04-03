//
//  ImagesListService.swift
//  Image Feed
//
//  Created by Анастасия Федотова on 28.03.2026.
//

import Foundation

final class ImagesListService {
    
    // MARK: - Properties
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    // MARK: - Initialization
    
    private init() {}
    
    private(set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    private let urlSession = URLSession.shared
    
    private lazy var dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    // MARK: - Public Methods
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let token = OAuth2TokenStorage.shared.token else { return }
        
        var urlComponents = URLComponents(string: Constants.defaultBaseURLString + "/photos")!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(nextPage)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            self.task = nil
            
            switch result {
            case .success(let photoResults):
                self.lastLoadedPage = nextPage
                
                let newPhotos = photoResults.map { result in
                    let date = result.createdAt.flatMap { self.dateFormatter.date(from: $0) }
                    return Photo(
                        id: result.id,
                        size: CGSize(width: result.width, height: result.height),
                        createdAt: date,
                        welcomeDescription: result.description,
                        thumbImageURL: result.urls.regular,
                        largeImageURL: result.urls.full,
                        isLiked: result.likedByUser
                    )
                }
                
                self.photos.append(contentsOf: newPhotos)
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                
            case .failure(let error):
                print("[ImagesListService]: fetchPhotosNextPage error - \(error.localizedDescription)")
            }
        }
        
        self.task = task
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let token = OAuth2TokenStorage.shared.token else { return }
        let urlString = Constants.defaultBaseURLString + "/photos/\(photoId)/like"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? HTTPMethod.post.rawValue : HTTPMethod.delete.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        _ = urlSession.data(for: request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked
                    )
                    self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                }
                completion(.success(()))
            case .failure(let error):
                print("[ImagesListService]: changeLike error - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func clean() {
        photos = []
        task?.cancel()
        task = nil
        lastLoadedPage = nil
    }
}

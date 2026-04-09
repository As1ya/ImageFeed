//
//  ImagesListPresenterSpy.swift
//  Image FeedTests
//
//  Created by Анастасия Федотова on 09.04.2026.
//

import XCTest
import Foundation
@testable import Image_Feed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var fetchPhotosNextPageCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        fatalError("Not implemented")
    }
    
    var photosCountResult: Int = 0
    func photosCount() -> Int {
        return photosCountResult
    }
    
    func photo(at index: Int) -> Image_Feed.Photo {
        fatalError("Not implemented")
    }
    
    func getCellConfig(for index: Int) -> (url: URL?, dateText: String, isLiked: Bool) {
        fatalError("Not implemented")
    }
}

//
//  ImagesListTests.swift
//  Image Feed
//
//  Created by Анастасия Федотова on 06.04.2026.
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

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    var updateTableViewAnimatedCalled: Bool = false
    var showErrorCalled: Bool = false
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        updateTableViewAnimatedCalled = true
    }
    
    func showError() {
        showErrorCalled = true
    }
}

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        viewController.configure(presenter)
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsFetchPhotos() {
        // given
        let presenter = ImagesListPresenterSpy()
        
        // when
        presenter.fetchPhotosNextPage()
        
        // then
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled)
    }
    
    func testViewControllerCallsFetchOnScroll() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        viewController.configure(presenter)
        
        // setup dummy row triggers
        presenter.photosCountResult = 10
        let triggerIndexPath = IndexPath(row: 9, section: 0)
        
        // when
        viewController.tableView(UITableView(), willDisplay: UITableViewCell(), forRowAt: triggerIndexPath)
        
        // then
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled)
    }
}

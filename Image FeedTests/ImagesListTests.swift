//
//  ImagesListTests.swift
//  Image Feed
//
//  Created by Анастасия Федотова on 06.04.2026.
//

import XCTest
import Foundation
@testable import Image_Feed

// MARK: - ImagesListTests

final class ImagesListTests: XCTestCase {
    
    // MARK: - Properties
    
    private var viewController: ImagesListViewController!
    private var presenter: ImagesListPresenterSpy!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as? ImagesListViewController
        
        presenter = ImagesListPresenterSpy()
        viewController.configure(presenter)
    }
    
    override func tearDown() {
        viewController = nil
        presenter = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testViewControllerCallsViewDidLoad() {
        // Given
        
        // When
        _ = viewController.view
        
        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsFetchPhotos() {
        // Given
        
        // When
        presenter.fetchPhotosNextPage()
        
        // Then
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled)
    }
    
    func testViewControllerCallsFetchOnScroll() {
        // Given
        presenter.photosCountResult = 10
        let triggerIndexPath = IndexPath(row: 9, section: 0)
        
        // When
        viewController.tableView(
            UITableView(),
            willDisplay: UITableViewCell(),
            forRowAt: triggerIndexPath
        )
        
        // Then
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled)
    }
}

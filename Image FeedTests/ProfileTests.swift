//
//  ProfileTests.swift
//  Image Feed
//
//  Created by Анастасия Федотова on 06.04.2026.
//

import XCTest
import Foundation
@testable import Image_Feed

// MARK: - ProfileTests

final class ProfileTests: XCTestCase {
    
    // MARK: - Properties
    
    private var viewController: ProfileViewController!
    private var presenter: ProfilePresenterSpy!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        viewController = ProfileViewController()
        presenter = ProfilePresenterSpy()
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
    
    func testLogoutCalled() {
        // Given
        
        // When
        presenter.logout()
        
        // Then
        XCTAssertTrue(presenter.logoutCalled)
    }
}

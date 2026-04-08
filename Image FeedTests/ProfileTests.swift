//
//  ProfileTests.swift
//  Image Feed
//
//  Created by Анастасия Федотова on 06.04.2026.
//

import XCTest
import Foundation
@testable import Image_Feed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled = false
    var logoutCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func logout() {
        logoutCalled = true
    }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var updateProfileDetailsCalled = false
    var updateAvatarCalled = false
    
    func updateProfileDetails(profile: Image_Feed.Profile) {
        updateProfileDetailsCalled = true
    }
    
    func updateAvatar(url: URL) {
        updateAvatarCalled = true
    }
}

final class ProfileTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.configure(presenter)
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testLogoutCalled() {
        // given
        let presenter = ProfilePresenterSpy()
        
        // when
        presenter.logout()
        
        // then
        XCTAssertTrue(presenter.logoutCalled)
    }
}

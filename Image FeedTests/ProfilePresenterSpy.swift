//
//  ProfilePresenterSpy.swift
//  Image FeedTests
//
//  Created by Анастасия Федотова on 09.04.2026.
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

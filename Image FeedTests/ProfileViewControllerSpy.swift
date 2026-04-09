//
//  ProfileViewControllerSpy.swift
//  Image FeedTests
//
//  Created by Анастасия Федотова on 09.04.2026.
//

import XCTest
import Foundation
@testable import Image_Feed

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

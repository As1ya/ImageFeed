//
//  ImagesListViewControllerSpy.swift
//  Image FeedTests
//
//  Created by Анастасия Федотова on 09.04.2026.
//

import XCTest
import Foundation
@testable import Image_Feed

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

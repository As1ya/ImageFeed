//
//  ProfileLogoutService.swift
//  Image Feed
//
//  Created by Анастасия Федотова on 31.03.2026.
//

import Foundation
import WebKit
import UIKit

final class ProfileLogoutService {
    
    // MARK: - Properties
    
    static let shared = ProfileLogoutService() 
  
    // MARK: - Initialization
    
    private init() { }

    // MARK: - Public Methods
    
    func logout() {
      cleanCookies()
      cleanAppData()
      switchToSplash()
   }

    // MARK: - Private Methods
    
    private func cleanCookies() {
       // Очищаем все куки из хранилища
      HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
      // Запрашиваем все данные из локального хранилища
      WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
         // Массив полученных записей удаляем из хранилища
         records.forEach { record in
            WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
         }
      }
   }
    
    private func cleanAppData() {
        OAuth2TokenStorage.shared.token = nil
        ProfileService.shared.clean()
        ProfileImageService.shared.clean()
        ImagesListService.shared.clean()
    }
    
    private func switchToSplash() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })
        else {
            assertionFailure("Invalid Configuration")
            return
        }
        
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
}

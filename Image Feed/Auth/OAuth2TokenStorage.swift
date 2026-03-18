//
//  OAuth2TokenStorage.swift
//  Image Feed
//
//  Created by Анастасия Федотова on 18.03.2026.
//

import Foundation

final class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "OAuthToken"
    
    var token: String? {
        get { userDefaults.string(forKey: tokenKey) }
        set { userDefaults.setValue(newValue, forKey: tokenKey) }
    }
}

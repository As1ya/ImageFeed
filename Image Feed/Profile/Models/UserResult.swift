//
//  UserResult.swift
//  Image Feed
//
//  Created by Анастасия Федотова on 25.03.2026.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

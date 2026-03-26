//
//  ProfileResult.swift
//  Image Feed
//
//  Created by Анастасия Федотова on 25.03.2026.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let first_name: String?
    let last_name: String?
    let bio: String?
}

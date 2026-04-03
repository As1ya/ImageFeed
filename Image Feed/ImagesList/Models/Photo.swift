//
//  Photo.swift
//  Image Feed
//
//  Created by Анастасия Федотова on 28.03.2026.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

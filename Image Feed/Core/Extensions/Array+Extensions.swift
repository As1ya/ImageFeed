//
//  Array+Extensions.swift
//  Image Feed
//
//  Created by Анастасия Федотова on 30.03.2026.
//

import Foundation

extension Array {
    func withReplaced(itemAt: Int, newValue: Element) -> [Element] {
        var elements = self
        elements[itemAt] = newValue
        return elements
    }
}

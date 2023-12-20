//
//  Item.swift
//  Gallery
//
//  Created by ANDREY STEPANOV on 15.12.23.
//

import Foundation

struct Item: Identifiable, Codable {
    var id: Int
    var name: String
    var imageUrl: String
}

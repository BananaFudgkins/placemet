//
//  Business.swift
//  Placemet
//
//  Created by Deja Jackson on 8/12/23.
//

import Foundation

struct Coordinates: Codable {
    let latitude: Double
    let longitude: Double
}

struct Business: Identifiable {
    var id: String?
    var name: String?
    var rating: Float?
    var price: String?
    var is_closed: Bool?
    var distance: Double?
    var address: String?
}

//
//  Response.swift
//  1.3.18_Assignment
//
//  Created by Kevin Yan on 1/4/18.
//  Copyright © 2018 Kevin Yan. All rights reserved.
//

import Foundation

struct Response: Codable {
    let results: [Place]
}

struct Place: Codable {
    let geometry: Geometry?
    let name: String?
    let price_level: Int?
    let rating: Double?
}

struct Geometry: Codable {
    let location: Location?
}

struct Location: Codable {
    let lat: Double?
    let lng: Double?
}


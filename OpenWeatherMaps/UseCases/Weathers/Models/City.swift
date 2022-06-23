//
//  City.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 22/06/2022.
//

import Foundation

/// A large human settlement.
struct City: Codable, Equatable {
    /// A unique identifier.
    let id: Int
    /// The city name.
    let name: String?
    /// The country that this city belongs to.
    let country: String?
    /// The time zone where this city located
    let timezone: Int?
}

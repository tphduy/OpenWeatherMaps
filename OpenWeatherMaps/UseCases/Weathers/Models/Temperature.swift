//
//  Temperature.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 22/06/2022.
//

import Foundation

/// An object abstracts the measured amount of heat in a place.
struct Temperature: Codable, Equatable {
    let min: Double?
    /// Max daily temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
    let max: Double?
    
    /// A type that can be used as a key for encoding and decoding.
    enum CodingKeys: String, CodingKey {
        case min
        case max
    }
}

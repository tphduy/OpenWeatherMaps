//
//  Temperature.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 22/06/2022.
//

import Foundation

/// An object abstracts the measured amount of heat in a place.
struct Temperature: Codable, Equatable {
    /// Day temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
    let day: Double?
    /// Night temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
    let night: Double?
    /// Min daily temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
    let min: Double?
    /// Max daily temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
    let max: Double?
    /// Evening temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
    let evening: Double?
    /// Morning temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
    let morning: Double?
    
    /// A type that can be used as a key for encoding and decoding.
    enum CodingKeys: String, CodingKey {
        case day
        case night
        case min
        case max
        case evening = "eve"
        case morning = "morn"
    }
}

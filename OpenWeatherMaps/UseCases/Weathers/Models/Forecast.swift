//
//  Forecast.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 22/06/2022.
//

import Foundation

/// The expected weather conditions what is judged likely to happen in the future.
struct Forecast: Codable, Equatable {
    /// The date that this forecast was publised.
    let date: Date
    /// The measured amount of heat in a place.
    let temperature: Temperature?
    /// The atmospheric pressure on the sea level. Unit default: hPa.
    let pressure: Double?
    /// The quality of being humid (formated as %).
    let humidity: Double?
    /// A list of weather conditions.
    let weather: [Weather]?

    /// A type that can be used as a key for encoding and decoding.
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temperature = "temp"
        case pressure
        case humidity
        case weather
    }
    
    /// An object abstract the weather condition.
    struct Weather: Codable, Equatable {
        /// A text that identifies a weather condition in a group of weather parameters (Rain, Snow, Extreme etc.)
        let main: String?
        /// The description of the weather condition within the group.
        let desc: String?

        /// A type that can be used as a key for encoding and decoding.
        enum CodingKeys: String, CodingKey {
            case main
            case desc = "description"
        }
    }
}

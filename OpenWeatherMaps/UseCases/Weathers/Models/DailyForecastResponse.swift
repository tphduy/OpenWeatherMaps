//
//  DailyForecastResponse.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 22/06/2022.
//

import Foundation

/// An object abstracts the daily forecasts of a city that will be returned from a remote database.
///
/// References: https://openweathermap.org/forecast16
struct DailyForecastResponse: Codable, Equatable {
    /// A place where the forecast data was returned from.
    let city: City
    /// A list of daily forecasts.
    let forecasts: [Forecast]
    
    /// A type that can be used as a key for encoding and decoding.
    enum CodingKeys: String, CodingKey {
        case city
        case forecasts = "list"
    }
}

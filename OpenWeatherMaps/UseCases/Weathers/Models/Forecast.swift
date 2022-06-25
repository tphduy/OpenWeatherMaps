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
    /// The sunrise time.
    let sunrise: Int?
    /// The sunset time.
    let sunset: Int?
    /// The measured amount of heat in a place.
    let temperature: Temperature?
    /// The estimated temperature in a day.
    let feelsLike: FeelsLike?
    /// The atmospheric pressure on the sea level. Unit default: hPa.
    let pressure: Double?
    /// The quality of being humid (formated as %).
    let humidity: Double?
    /// A list of weather conditions.
    let weather: [Weather]?
    /// The wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
    let speed: Double?
    /// The wind direction. Unit Default: degrees (meteorological)
    let direction: Int?
    /// The wind gust. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
    let gust: Double?
    /// The cloudiness (formated as %).
    let clouds: Double?
    /// The snow volume. Unit Default: mm.
    let pop: Double?
    /// The probability of precipitation (formated as %).
    let rain: Double?

    /// A type that can be used as a key for encoding and decoding.
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case sunrise
        case sunset
        case temperature = "temp"
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case weather
        case speed
        case direction = "direction"
        case gust
        case clouds
        case pop
        case rain
    }
    
    /// An object abstracts the estimated temperature in a day.
    struct FeelsLike: Codable, Equatable {
        /// Day temperature.This temperature parameter accounts for the human perception of weather. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
        let day: Double?
        /// Night temperature.This temperature parameter accounts for the human perception of weather. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
        let night: Double?
        /// Evening temperature.This temperature parameter accounts for the human perception of weather. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
        let evening: Double?
        /// Morning temperature. This temperature parameter accounts for the human perception of weather. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
        let morning: Double?
        
        /// A type that can be used as a key for encoding and decoding.
        enum CodingKeys: String, CodingKey {
            case day
            case night
            case evening = "eve"
            case morning = "morn"
        }
    }
    
    /// An object abstract the weather condition.
    struct Weather: Codable, Equatable {
        /// A text that identifies a weather condition in a group of weather parameters (Rain, Snow, Extreme etc.)
        let main: String?
        /// The description of the weather condition within the group.
        let desc: String?
        /// A value that identifies the location of an icon.
        let icon: URL?

        /// A type that can be used as a key for encoding and decoding.
        enum CodingKeys: String, CodingKey {
            case main
            case desc = "description"
            case icon
        }
    }
}

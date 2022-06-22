//
//  WeatherUseCase.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 22/06/2022.
//

import Foundation

/// An object that manages the weather data and apply business rules to achive a use case.
///
/// The use cases situated on top of models and the “ports” for the data access layer (used for dependency inversion, usually Repository interfaces), retrieve and store domain models by using either repositories or other use cases.
protocol WeatherUseCase {
    /// Get the current weather data of a city.
    /// - Parameters:
    ///   - keyword: It is city name, state code and country code divided by comma, use ISO 3166 country codes. You can specify the parameter not only in English. In this case, the data be returned in the same language as the language of requested location name if the location is in the predefined list.
    ///   - numberOfDays: The number of forecast days you want to receive.
    ///   - promise: A promise to be fulfilled with a result represents either a success or a failure.
    func dailyForecast(
        keyword: String,
        numberOfDays: Int,
        promise: @escaping (Result<Void, Error>) -> Void
    )
}

/// An object that manages the weather data and apply business rules to achive a use case.
struct DefaultWeatherUseCase: WeatherUseCase {
    // MARK: WeatherUseCase
    
    func dailyForecast(
        keyword: String,
        numberOfDays: Int,
        promise: @escaping (Result<Void, Error>) -> Void
    ) {}
}
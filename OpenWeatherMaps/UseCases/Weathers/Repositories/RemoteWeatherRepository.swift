//
//  RemoteWeatherRepository.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 23/06/2022.
//

import Foundation

/// An object provides methods for interacting with the weather data in the remote database.
protocol RemoteWeatherRepository {
    /// Get the current weather data of a city.
    /// - Parameters:
    ///   - keyword: It is city name, state code and country code divided by comma, use ISO 3166 country codes. You can specify the parameter not only in English. In this case, the data be returned in the same language as the language of requested location name if the location is in the predefined list.
    ///   - numberOfDays: The number of forecast days you want to receive.
    func dailyForecast(
        keyword: String,
        numberOfDays: Int
    ) async throws -> DailyForecastResponse
}

/// An object provides methods for interacting with the weather data in the remote database.
struct DefaultRemoteWeatherRepository: RemoteWeatherRepository {
    // MARK: RemoteWeatherRepository
    
    func dailyForecast(
        keyword: String,
        numberOfDays: Int
    ) async throws  -> DailyForecastResponse {
        fatalError("not implemented")
    }
}

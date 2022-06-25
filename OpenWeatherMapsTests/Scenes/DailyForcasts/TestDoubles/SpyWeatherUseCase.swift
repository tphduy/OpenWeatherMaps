//
//  SpyWeatherUseCase.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Tran on 25/06/2022.
//

import Foundation
@testable import OpenWeatherMaps

final class SpyWeatherUseCase: WeatherUseCase {

    var invokedDailyForecast = false
    var invokedDailyForecastCount = 0
    var invokedDailyForecastParameters: (keywords: String, numberOfDays: Int)?
    var invokedDailyForecastParametersList = [(keywords: String, numberOfDays: Int)]()
    var stubbedDailyForecastResult: DailyForecastResponse!
    var stubbedDailyForecastError: Error?

    func dailyForecast(
        keywords: String,
        numberOfDays: Int
    ) async throws -> DailyForecastResponse {
        invokedDailyForecast = true
        invokedDailyForecastCount += 1
        invokedDailyForecastParameters = (keywords, numberOfDays)
        invokedDailyForecastParametersList.append((keywords, numberOfDays))
        if let error = stubbedDailyForecastError {
            throw error
        }
        return stubbedDailyForecastResult
    }
}

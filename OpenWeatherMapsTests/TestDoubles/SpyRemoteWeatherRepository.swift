//
//  SpyRemoteWeatherRepository.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Tran on 23/06/2022.
//

import Foundation
@testable import OpenWeatherMaps

final class SpyRemoteWeatherRepository: RemoteWeatherRepository {
    
    var invokedDailyForecast = false
    var invokedDailyForecastCount = 0
    var invokedDailyForecastParameters: (keywords: String, numberOfDays: Int)?
    var invokedDailyForecastParametersList = [(keywords: String, numberOfDays: Int)]()
    var stubbedDailyForecastError: Error?
    var stubbedDailyForecastResult: DailyForecastResponse!

    func dailyForecast(
        keywords: String,
        numberOfDays: Int
    ) async throws -> DailyForecastResponse {
        invokedDailyForecast = true
        invokedDailyForecastCount += 1
        invokedDailyForecastParameters = (keywords, numberOfDays)
        invokedDailyForecastParametersList.append((keywords, numberOfDays))
        if let error = stubbedDailyForecastError { throw error }
        return stubbedDailyForecastResult
    }
}

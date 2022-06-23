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
    var invokedDailyForecastParameters: (keyword: String, numberOfDays: Int)?
    var invokedDailyForecastParametersList = [(keyword: String, numberOfDays: Int)]()
    var stubbedDailyForecastError: Error?
    var stubbedDailyForecastResult: DailyForecastResponse!

    func dailyForecast(
        keyword: String,
        numberOfDays: Int
    ) async throws -> DailyForecastResponse {
        invokedDailyForecast = true
        invokedDailyForecastCount += 1
        invokedDailyForecastParameters = (keyword, numberOfDays)
        invokedDailyForecastParametersList.append((keyword, numberOfDays))
        if let error = stubbedDailyForecastError { throw error }
        return stubbedDailyForecastResult
    }
}

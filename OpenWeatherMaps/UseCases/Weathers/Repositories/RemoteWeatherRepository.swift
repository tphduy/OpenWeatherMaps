//
//  RemoteWeatherRepository.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 23/06/2022.
//

import Foundation
import Networkable

/// An object provides methods for interacting with the weather data in the remote database.
protocol RemoteWeatherRepository {
    /// Get the daily forecast of a place.
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
    // MARK: Dependencies
    
    /// An ad-hoc network layer built on `URLSession` to perform an HTTP request.
    private let provider: WebRepository
    
    // MARK: Init
    
    /// Initiate an object provides methods for interacting with the weather data in the remote database.
    /// - Parameter provider: An ad-hoc network layer built on `URLSession` to perform an HTTP request. The default value is `.openWeatherMaps`.
    init(provider: WebRepository = DefaultWebRepository.openWeatherMaps) {
        self.provider = provider
    }
    
    // MARK: RemoteWeatherRepository
    
    func dailyForecast(
        keyword: String,
        numberOfDays: Int
    ) async throws -> DailyForecastResponse {
        let endpoint = APIEndpoint.dailyForecast(keyword: keyword, numberOfDays: numberOfDays)
        return try await provider.call(to: endpoint)
    }
    
    // MARK: Endpoint
    
    /// A type that represents the available API endpoint.
    enum APIEndpoint: Endpoint {
        /// Get the daily forecast of a place.
        case dailyForecast(keyword: String, numberOfDays: Int)
        
        var headers: [String : String]? { nil }
        
        var url: String {
            switch self {
            case let .dailyForecast(keyword, numberOfDays):
                return "/data/2.5/forecast/daily?"
                + "q=\(keyword)"
                + "&cnt=\(numberOfDays)"
            }
        }
        
        var method: Networkable.Method { .get }
        
        func body() throws -> Data? { nil }
    }
}

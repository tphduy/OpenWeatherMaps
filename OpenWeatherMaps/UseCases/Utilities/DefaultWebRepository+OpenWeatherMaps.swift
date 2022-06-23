//
//  DefaultWebRepository+OpenWeatherMaps.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 23/06/2022.
//

import Foundation
import Networkable

extension DefaultWebRepository {
    /// A shared instance that connects to the OpenWeatherMap APIs (https://openweathermap.org).
    static var openWeatherMaps: Self {
        let baseURL = URL(string: Natrium.Config.openWeatherMapURL)
        let requestBuilder = URLRequestBuilder(baseURL: baseURL)
        let result = DefaultWebRepository(requestBuilder: requestBuilder, middlewares: [LoggingMiddleware()])
        return result
    }
}

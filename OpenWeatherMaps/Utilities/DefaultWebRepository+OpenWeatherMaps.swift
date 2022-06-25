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
        let baseURL = URL(string: Natrium.Config.openWeatherMapAPI)
        let requestBuilder = URLRequestBuilder(baseURL: baseURL)
        let authorizationMiddleware = AuthorizationMiddleware(
            key: "appid",
            value: Natrium.Config.appID,
            place: .query)
        let result = DefaultWebRepository(
            requestBuilder: requestBuilder,
            middlewares: [
                authorizationMiddleware,
                LocalizationMiddleware(),
                StatusCodeValidationMiddleware(),
                LoggingMiddleware(),
            ])
        return result
    }
}

//
//  NetworkSession+OpenWeatherMaps.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 23/06/2022.
//

import Foundation
import Networkable

extension NetworkSession {
    /// A shared instance that connects to the OpenWeatherMap APIs (https://openweathermap.org).
    static var openWeatherMaps: NetworkSession {
        let baseURL = URL(string: Natrium.Config.openWeatherMapAPI)
        let requestBuilder = URLRequestBuilder(baseURL: baseURL)
        let authorizationMiddleware = AuthorizationMiddleware(
            key: "appid",
            value: Natrium.Config.appID,
            place: .query)
        let middlewares: [Middleware] = [
            authorizationMiddleware,
            LocalizationMiddleware(),
            LoggingMiddleware(log: .networking),
            ErrorDecoderMiddleware<OpenWeatherMapsError>(),
            StatusCodeValidationMiddleware(),
        ]
        let result = NetworkSession(
            requestBuilder: requestBuilder,
            middlewares: middlewares)
        return result
    }
}

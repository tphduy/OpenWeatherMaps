//
//  DailyForecastsBuilder.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 25/06/2022.
//

import UIKit

/// An object helps to build a daily forecasts scene that display the daily forecasts of a place.
struct DailyForecastsBuilder {
    // MARK: Dependencies
    
    /// An object that manages the weather data and apply business rules to achive a use case. The default value is an instance of `DefaultWeatherUseCase`
    var weatherUseCase: WeatherUseCase = DefaultWeatherUseCase()
    
    // MARK: Build

    /// Build a scene that displays the daily forecasts of a place.
    /// - Parameters:
    ///   - listener: An object manages interactions.
    /// - Returns: A view controller.
    func build(listener: DailyForecastsListener? = nil) -> UIViewController {
        let presenter = DailyForecastsPresenter(weatherUseCase: weatherUseCase)
        let viewController = DailyForecastsViewController(presenter: presenter)
        presenter.view = viewController
        presenter.coordinator = viewController
        presenter.listener = listener
        return viewController
    }
}

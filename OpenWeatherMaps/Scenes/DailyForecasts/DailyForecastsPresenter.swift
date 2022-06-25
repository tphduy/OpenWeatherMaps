//
//  DailyForecastsPresenter.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 25/06/2022.
//

import Foundation

/// An object that takes responsibility for routing through the app.
protocol DailyForecastsCoordinating: AnyObject {}

/// An object that manages the interactions with the daily forecasts scene.
protocol DailyForecastsListener: AnyObject {}

/// A passive object that displays the daily forecasts of a place.
protocol DailyForecastsViewable: AnyObject {
    /// Reload all data.
    func reloadData()
}

/// An object that acts upon the daily forecasts data and the associated view to display the daily forecasts of a place.
final class DailyForecastsPresenter: DailyForecastsPresentable {
    // MARK: Dependencies
    
    /// An object that manages the weather data and apply business rules to achive a use case.
    private let weatherUseCase: WeatherUseCase

    /// An object that takes responsibility for routing through the app.
    weak var coordinator: DailyForecastsCoordinating?

    /// An object that manages the interactions.
    weak var listener: DailyForecastsListener?

    /// A passive object that displays the daily forecasts of a place.
    weak var view: DailyForecastsViewable?

    // MARK: Misc
    
    /// A list of daily forecasts.
    private var forecasts: [Forecast] = []
    
    /// An asynchronous task that reload all data.
    private var reloadDataTask: Task<Void, Error>?

    // MARK: Init
    
    /// Initiate a presenter that acts upon the daily forecasts data and the associated view to display the daily forecasts of a place.
    /// - Parameter weatherUseCase: An object that manages the weather data and apply business rules to achive a use case. The default value is an instance of `DefaultWeatherUseCase`
    init(weatherUseCase: WeatherUseCase = DefaultWeatherUseCase()) {
        self.weatherUseCase = weatherUseCase
    }

    // MARK: Side Effects
    
    /// Reload all data with a new search criteria.
    /// - Parameter keywords: The textual content of the search criteria.
    private func reloadData(withKeywords keywords: String) {
        reloadDataTask?.cancel()
        reloadDataTask = Task {
            do {
                let result = try await weatherUseCase.dailyForecast(keyword: keywords, numberOfDays: 7)
                let forecasts = result.forecasts
                reloadData(withForecasts: forecasts)
            } catch {
                // TODO: Ask view to show error.
                print(error)
            }
        }
    }
    
    /// Replace the current data with new data if it is different.
    /// - Parameter forecasts: A list of forecasts.
    private func reloadData(withForecasts forecasts: [Forecast]) {
        guard self.forecasts != forecasts else { return }
        self.forecasts = forecasts
        self.reloadView()
    }
    
    /// Ask the view to reload all data.
    ///
    /// This method always invokes the view to reload data on the main thread.
    private func reloadView() {
        guard let view = view else { return }
        guard !Thread.isMainThread else { return view.reloadData() }
        DispatchQueue.main.async(execute: view.reloadData)
    }

    // MARK: Utilities

    // MARK: DailyForecastsViewable

    func viewDidLoad() {}
    
    func viewDidDisappear() {
        reloadDataTask?.cancel()
    }
    
    func keywordsDidChange(_ keywords: String?) {
        guard let keywords = keywords, !keywords.isEmpty else { return reloadData(withForecasts: []) }
        reloadData(withKeywords: keywords)
    }
    
    func numberOfSections() -> Int {
        forecasts.isEmpty ? 0 : 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        forecasts.count
    }
    
    func item(at indexPath: IndexPath) -> Forecast {
        forecasts[indexPath.item]
    }
}

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
protocol DailyForecastsViewable: AnyObject {}

/// An object that acts upon the daily forecasts data and the associated view to display the daily forecasts of a place.
final class DailyForecastsPresenter: DailyForecastsPresentable {
    // MARK: Dependencies

    /// An object that takes responsibility for routing through the app.
    weak var coordinator: DailyForecastsCoordinating?

    /// An object that manages the interactions.
    weak var listener: DailyForecastsListener?

    /// A passive object that displays the daily forecasts of a place.
    weak var view: DailyForecastsViewable?

    // MARK: Misc
    
    /// A list of forecasts.
    private var forecasts: [Forecast] = []

    // MARK: Init
    
    /// Initiate a presenter that acts upon the daily forecasts data and the associated view to display the daily forecasts of a place.
    init() {}

    // MARK: Side Effects

    // MARK: Utilities

    // MARK: DailyForecastsViewable

    func viewDidLoad() {}
    
    func keywordsDidChange(_ keywords: String?) {}
    
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

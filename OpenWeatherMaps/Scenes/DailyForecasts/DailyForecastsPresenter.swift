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
    
    /// Show or hide a loading indicator over the current context.
    /// - Parameter isLoading: Specify `true` to show a loading indicator, `false` to hide.
    func toggleLoading(_ isLoading: Bool)
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
    private(set) var forecasts: [Forecast] = []
    
    /// The last keywords.
    private(set) var lastKeywords: String = ""
    
    /// An asynchronous task that reload all data.
    private(set) var reloadDataTask: Task<Void, Error>?
    
    /// An asynchronous task that reload all data after a specific time.
    private(set) var pendingReloadDatatWorkItem: DispatchWorkItem?

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
                updateLayout { [weak self] in self?.view?.toggleLoading(true) }
                let result = try await weatherUseCase.dailyForecast(keywords: keywords, numberOfDays: 7)
                updateLayout { [weak self] in self?.view?.toggleLoading(false) }
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
        (view?.reloadData).map(updateLayout(_:))
    }
    
    /// Verify the current thread to make sure the task is always executed on the main thread.
    /// - Parameter task: A task that updates the layout.
    private func updateLayout(_ task: @escaping () -> Void) {
        guard !Thread.isMainThread else { return task() }
        DispatchQueue.main.async(execute: task)
    }

    // MARK: DailyForecastsViewable

    func viewDidLoad() {}
    
    func viewDidDisappear() {
        reloadDataTask?.cancel()
    }
    
    func keywordsDidChange(_ keywords: String) {
        guard keywords != lastKeywords else { return }
        lastKeywords = keywords
        // Cancel the currently pending item
        pendingReloadDatatWorkItem?.cancel()
        // Wrap a new task in an item.
        let item = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            // Determine whether the keywords are none or empty to discard the current data.
            guard !keywords.isEmpty else { return self.reloadData(withForecasts: []) }
            // Send a new request to reload data with the keywords.
            self.reloadData(withKeywords: keywords)
        }
        // Keep a reference to the pending task for canceling if needed.
        pendingReloadDatatWorkItem = item
        // Schedule to execute the task after a specific time.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: item)
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

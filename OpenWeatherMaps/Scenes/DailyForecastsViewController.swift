//
//  DailyForecastsViewController.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 25/06/2022.
//

import UIKit

/// An object that acts upon the daily forecasts data and the associated view to displays the daily forecasts of a place.
protocol DailyForecastsPresentable: AnyObject {
    /// Notify the view is loaded into memory.
    func viewDidLoad()
}

/// A passive view controller that displays the daily forecasts of a place.
final class DailyForecastsViewController: UIViewController, DailyForecastsViewable {
    // MARK: UIs

    // MARK: Dependencies
    
    /// An object that acts upon the daily forecasts data and the associated view to displays the daily forecasts of a place.
    let presenter: DailyForecastsPresentable

    // MARK: Init

    /// Initiate a passive view controller that displays the daily forecasts of a place.
    /// - Parameter presenter: An object that acts upon the daily forecasts data and the associated view to displays the daily forecasts of a place.
    init(presenter: DailyForecastsPresentable) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    // MARK: Side Effects

    // MARK: Utilities

    // MARK: DailyForecastsViewable
}

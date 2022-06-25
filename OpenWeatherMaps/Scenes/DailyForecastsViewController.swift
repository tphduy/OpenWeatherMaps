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
    
    /// A view controller that manages the display of search results based on interactions with a search bar.
    private(set) lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = NSLocalizedString("A city name", comment: "A search bar placeholder")
        return controller
    }()

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
        let presenter = DailyForecastsPresenter()
        self.presenter = presenter
        super.init(coder: coder)
        presenter.view = self
        presenter.coordinator = self
    }

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        presenter.viewDidLoad()
    }
    
    // MARK: Side Effects

    // MARK: Utilities

    // MARK: DailyForecastsViewable
}

extension DailyForecastsViewController: UISearchResultsUpdating {
    // MARK: UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {}
}

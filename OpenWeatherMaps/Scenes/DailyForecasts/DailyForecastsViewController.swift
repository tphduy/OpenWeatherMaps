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
    
    /// Notify that the keywords did change.
    /// - Parameter keywords: The textual content of the search criteria.
    func keywordsDidChange(_ keywords: String?)
    
    /// Ask for the number of sections in a list layout.
    /// - Returns: The number of sections in a list layout.
    func numberOfSections() -> Int
    
    /// Ask for the number of items in the specified section.
    /// - Parameter section: An index number identifying a section.
    /// - Returns: The number of items in section.
    func numberOfItems(in section: Int) -> Int
    
    /// Ask for a item that is specified by an index path.
    /// - Parameter indexPath: The index path that specifies the location of an item.
    /// - Returns: The data model of an item.
    func item(at indexPath: IndexPath) -> Forecast
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
    
    /// A layout object that combines items in a list layout.
    private(set) lazy var collectionViewLayout: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1000))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    /// An object that manages an ordered collection of daily forecasts items and presents them using `collectionViewLayout`.
    private(set) lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        view.dataSource = self
        view.delegate = self
        view.allowsSelection = false
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ForecastCollectionViewCell.self))
        return view
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

    override func loadView() {
        super.loadView()
        view.addSubview(collectionView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        definesPresentationContext = true
        presenter.viewDidLoad()
    }
    
    // MARK: Side Effects

    // MARK: Utilities

    // MARK: DailyForecastsViewable
}

extension DailyForecastsViewController: UISearchResultsUpdating {
    // MARK: UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        presenter.keywordsDidChange(searchController.searchBar.text)
    }
}

extension DailyForecastsViewController: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems(in: section)
    }
}

extension DailyForecastsViewController: UICollectionViewDelegate {
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ForecastCollectionViewCell.self), for: indexPath)
        guard let cell = cell as? ForecastCollectionViewCell else { return cell }
        cell.configure(withForecast: presenter.item(at: indexPath))
        return cell
    }
}
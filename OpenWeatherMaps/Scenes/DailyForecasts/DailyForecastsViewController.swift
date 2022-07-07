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
    
    /// Notify the view was removed from a view hierarchy.
    func viewDidDisappear()
    
    /// Notify that the keywords did change.
    /// - Parameter keywords: The textual content of the search criteria.
    func keywordsDidChange(_ keywords: String)
    
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
        controller.searchBar.accessibilityTraits = .searchField
        controller.searchBar.accessibilityLabel = "Search"
        controller.searchBar.isAccessibilityElement = true
        return controller
    }()
    
    /// A layout object that combines items in a list layout.
    private(set) lazy var collectionViewLayout = UICollectionViewCompositionalLayout { (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) in
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        var section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
        section.interGroupSpacing = 8
        return section
    }
    
    /// An object that manages an ordered collection of daily forecasts items and presents them using `collectionViewLayout`.
    private(set) lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        view.dataSource = self
        view.delegate = self
        view.allowsSelection = false
        view.keyboardDismissMode = .onDrag
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ForecastCollectionViewCell.self))
        return view
    }()
    
    /// A view that shows that a task is in progress.
    private(set) lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A discrete gesture recognizer that interprets single tap.
    private(set) lazy var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
        target: searchController.searchBar,
        action: #selector(searchController.searchBar.endEditing))

    // MARK: Dependencies
    
    /// An object that acts upon the daily forecasts data and the associated view to displays the daily forecasts of a place.
    let presenter: DailyForecastsPresentable
    
    // MARK: Misc
    
    /// A formatter that converts between dates and their textual representations.
    private(set) lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter
    }()
    
    /// A formatter that provides localized representations of units and measurements.
    private(set) lazy var measurementFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        return formatter
    }()
    
    /// An object helps to Initiate an object helps to make an URL of an image.
    private(set) lazy var imageURLFactory = ImageURLFactory()

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
        view.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(collectionView)
        view.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        definesPresentationContext = true
        presenter.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.viewDidDisappear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: DailyForecastsViewable
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func showLoading() {
        activityIndicatorView.startAnimating()
    }
    
    func hideLoading() {
        activityIndicatorView.stopAnimating()
    }
    
    func showError(_ error: Error) {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.text = error.localizedDescription
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let containerView = UIView()
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = .systemRed
        containerView.alpha = 0
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(label)
        
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            label.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
        ])
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: { [weak containerView] in
            containerView?.alpha = 1
        }, completion: { [weak containerView] (_: Bool) in
            UIView.animate(withDuration: 0.25, delay: 2, options: .curveEaseOut) {
                containerView?.alpha = 0
            } completion: { [weak containerView] (_: Bool) in
                containerView?.removeFromSuperview()
            }
        })
    }
}

import Combine

extension DailyForecastsViewController: UISearchResultsUpdating {
    // MARK: UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        presenter.keywordsDidChange(searchController.searchBar.text ?? "")
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
        let forecast = presenter.item(at: indexPath)
        cell.configure(
            withForecast: forecast,
            dateFormatter: dateFormatter,
            measurementFormatter: measurementFormatter,
            imageURLFactory: imageURLFactory)
        return cell
    }
}

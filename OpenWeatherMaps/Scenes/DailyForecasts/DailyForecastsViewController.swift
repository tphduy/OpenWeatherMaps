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
    
    /// Notify the view was added to a view hierarchy.
    func viewDidAppear()
    
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
        controller.searchBar.accessibilityLabel = NSLocalizedString("Search city", comment: "A search bar accessibility label")
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
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
    
    func startEditing() {
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
    }
    
    func reloadData() {
        collectionView.reloadData()
        UIAccessibility.post(notification: .layoutChanged, argument: nil)
    }
    
    func showLoading() {
        activityIndicatorView.startAnimating()
    }
    
    func hideLoading() {
        activityIndicatorView.stopAnimating()
    }
    
    func showError(_ error: Error) {
        let content = makeErrorView(error: error)
        let toast = makeToastView(content: content, backgroundColor: .systemRed)
        showToast(toast, in: view)
    }
    
    // MARK: Utilities
    
    /// Show a toast view in a container view for a specific time interval.
    /// - Parameters:
    ///   - toast: A view that displays a toast.
    ///   - containerView: The view that will contains the toast view.
    ///   - visibleTime: The time interval that the toast will be visible before being removed. The default value is `2`.
    ///   - animationDuration: The duration of the appearing animation and  the disappearing animation. The default value is `0.25`.
    private func showToast(
        _ toast: UIView,
        in containerView: UIView,
        for visibleTime: TimeInterval = 2,
        withAnimationDuration animationDuration: TimeInterval = 0.25
    ) {
        containerView.addSubview(toast)
        NSLayoutConstraint.activate([
            toast.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            toast.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            toast.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
        ])
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: { [weak toast] in
            toast?.alpha = 1
        }, completion: { [weak toast] (_: Bool) in
            UIView.animate(withDuration: animationDuration, delay: visibleTime, options: .curveEaseOut) {
                toast?.alpha = 0
            } completion: { [weak toast] (_: Bool) in
                toast?.removeFromSuperview()
            }
        })
    }
    
    /// Make a view that displays an error.
    /// - Parameter error: A type representing an error value that can be thrown.
    /// - Returns: An instance of `UILabel`.
    private func makeErrorView(error: Error) -> UILabel {
        let view = UILabel()
        view.textColor = .white
        view.font = .systemFont(ofSize: 14)
        view.text = error.localizedDescription
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    /// Make a view that wraps a content view within as a toast.
    /// - Parameters:
    ///   - content: A view that displays the content of a toast.
    ///   - backgroundColor: The background color of the toast.
    /// - Returns: An instance of `UIView`.
    private func makeToastView(content: UIView, backgroundColor: UIColor) -> UIView {
        let toast = UIView()
        toast.layer.masksToBounds = true
        toast.layer.cornerRadius = 8
        toast.backgroundColor = backgroundColor
        toast.alpha = 0
        toast.translatesAutoresizingMaskIntoConstraints = false
        toast.addSubview(content)
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: toast.safeAreaLayoutGuide.topAnchor, constant: 8),
            content.leadingAnchor.constraint(equalTo: toast.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            content.bottomAnchor.constraint(equalTo: toast.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            content.trailingAnchor.constraint(equalTo: toast.safeAreaLayoutGuide.trailingAnchor, constant: -8),
        ])
        return toast
    }
}

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

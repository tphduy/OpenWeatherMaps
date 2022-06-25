//
//  DailyForecastsViewController.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Tran on 25/06/2022.
//

import XCTest
@testable import OpenWeatherMaps

final class DailyForecastsViewControllerTests: XCTestCase {
    // MARK: Misc
    
    private var presenter: SpyDailyForecastsPresenter!
    private var sut: DailyForecastsViewController!
    
    // MARK: Life Cycle

    override func setUpWithError() throws {
        presenter = makePresenter()
        sut = DailyForecastsViewController(presenter: presenter)
    }

    override func tearDownWithError() throws {
        presenter = nil
        sut = nil
    }
    
    // MARK: Test Case - loadView()
    
    func test_loadView() throws {
        sut.loadView()
        
        XCTAssertTrue(sut.collectionView.isDescendant(of: sut.view))
    }
    
    // MARK: Test Case - viewDidLoad()
    
    func test_viewDidLoad() throws {
        sut.viewDidLoad()
        
        XCTAssertIdentical(sut.navigationItem.searchController, sut.searchController)
        XCTAssertTrue(sut.definesPresentationContext)
        XCTAssertTrue(presenter.invokedViewDidLoad)
    }
    
    // MARK: Test Case - viewDidDisappear()
    
    func test_viewDidDisappear() throws {
        sut.viewDidDisappear(false)
        
        XCTAssertTrue(presenter.invokedViewDidDisappear)
    }
    
    // MARK: Test Case - reloadData()
    
    func test_reloadData() throws {
        sut.reloadData()
    }
    
    // MARK: Test Case - updateSearchResults(for:)
    
    func test_updateSearchResults() throws {
        let keywords = "foo bar"
        sut.searchController.searchBar.text = keywords
        
        sut.updateSearchResults(for: sut.searchController)
        
        XCTAssertTrue(presenter.invokedKeywordsDidChange)
        XCTAssertEqual(presenter.invokedKeywordsDidChangeParameters?.keywords, keywords)
    }
    
    // MARK: Test Case - numberOfSections(in:) {
    
    func test_numberOfSections() throws {
        let result = sut.numberOfSections(in: sut.collectionView)
        
        XCTAssertTrue(presenter.invokedNumberOfSections)
        XCTAssertEqual(result, presenter.stubbedNumberOfItemsResult)
    }
    
    // MARK: Test Case - collectionView(_:numberOfItemsInSection:)
    
    func test_numberOfItemsInSection() throws {
        let section = 0
        let result = sut.collectionView(sut.collectionView, numberOfItemsInSection: section)
        
        XCTAssertTrue(presenter.invokedNumberOfItems)
        XCTAssertEqual(presenter.invokedNumberOfItemsParameters?.section, section)
        XCTAssertEqual(presenter.stubbedNumberOfItemsResult, result)
    }
    
    // MARK: Test Case - collectionView(_:cellForItemAt:)
    
    func test_cellForItemAtIndexPath() throws {
        let indexPath = IndexPath(item: 0, section: 0)
        let result = sut.collectionView(sut.collectionView, cellForItemAt: indexPath)
        
        XCTAssertTrue(presenter.invokedItem)
        XCTAssertEqual(presenter.invokedItemParameters?.indexPath, indexPath)
        XCTAssertTrue(result is ForecastCollectionViewCell)
    }
}

extension DailyForecastsViewControllerTests {
    // MARK: Utilities
    
    private func makePresenter() -> SpyDailyForecastsPresenter {
        let result = SpyDailyForecastsPresenter()
        result.stubbedItemResult = .dummy
        return result
    }
}

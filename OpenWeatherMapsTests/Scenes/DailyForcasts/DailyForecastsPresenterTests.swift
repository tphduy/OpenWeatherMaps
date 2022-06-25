//
//  DailyForecastsPresenterTests.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Tran on 25/06/2022.
//

import XCTest
@testable import OpenWeatherMaps

final class DailyForecastsPresenterTests: XCTestCase {
    // MARK: Misc
    
    private var sut: DailyForecastsPresenter!
    
    // MARK: Life Cycle

    override func setUpWithError() throws {
        sut = DailyForecastsPresenter()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: Test Case - viewDidLoad()
    
    func test_viewDidLoad() throws {
        sut.viewDidLoad()
    }
    
    // MARK: Test Case - keywordsDidChange(_:)
    
    func test_keywordsDidChange() throws {
        let keywords = "foo bar"
        sut.keywordsDidChange(keywords)
    }
    
    // MARK: Test Case - numberOfSections()
    
    func test_numberOfSections() throws {
        XCTAssertEqual(sut.numberOfSections(), 0)
    }
    
    // MARK: Test Case - numberOfItems(in:)
    
    func test_numberOfItems() throws {
        XCTAssertEqual(sut.numberOfItems(in: 0), 0)
    }
    
    // MARK: Test Case - item(at:)
    
    func test_itemAtIndexPath() throws {}
}

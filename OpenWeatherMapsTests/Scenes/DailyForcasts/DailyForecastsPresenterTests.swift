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
    
    private var weatherUseCase: SpyWeatherUseCase!
    private var view: SpyDailyForecastsView!
    private var sut: DailyForecastsPresenter!
    
    // MARK: Life Cycle

    override func setUpWithError() throws {
        weatherUseCase = makeWeatherUseCase()
        view = SpyDailyForecastsView()
        sut = DailyForecastsPresenter(weatherUseCase: weatherUseCase)
        sut.view = view
    }

    override func tearDownWithError() throws {
        weatherUseCase = nil
        view = nil
        sut = nil
    }
    
    // MARK: Test Case - viewDidLoad()
    
    func test_viewDidLoad() throws {
        sut.viewDidLoad()
    }
    
    // MARK: Test Case - viewDidDisappear()
    
    func test_viewDidDisappear() throws {
        sut.viewDidDisappear()
    }
    
    // MARK: Test Case - keywordsDidChange(_:)
    
    func test_keywordsDidChange_whenInvokedMultipleTime() throws {
        let expectation = self.expectation(description: "expected the data will reload after a while with the last keyword")
        
        XCTAssertNil(sut.pendingReloadDatatWorkItem)
        
        sut.keywordsDidChange("foo")
        
        XCTAssertNotNil(sut.pendingReloadDatatWorkItem)
        
        let lastItem = sut.pendingReloadDatatWorkItem
        
        sut.keywordsDidChange("bar")
        
        XCTAssertNotNil(sut.pendingReloadDatatWorkItem)
        XCTAssertNotIdentical(sut.pendingReloadDatatWorkItem, lastItem)
        
        sut.pendingReloadDatatWorkItem?.notify(queue: .main) {
            XCTAssertTrue(self.weatherUseCase.invokedDailyForecast)
            XCTAssertEqual(self.weatherUseCase.invokedDailyForecastParameters?.keywords, "bar")
            XCTAssertEqual(self.sut.forecasts, self.weatherUseCase.stubbedDailyForecastResult.forecasts)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func test_keywordsDidChange_whenNewValueIsSome() throws {
        let expectation = self.expectation(description: "expected the data will reload after a while")
        
        XCTAssertNil(sut.pendingReloadDatatWorkItem)
        XCTAssertNil(sut.reloadDataTask)
        
        sut.keywordsDidChange("foo")
        
        XCTAssertNotNil(sut.pendingReloadDatatWorkItem)
        XCTAssertNil(sut.reloadDataTask)
        
        sut.pendingReloadDatatWorkItem?.notify(queue: .main) {
            XCTAssertTrue(self.weatherUseCase.invokedDailyForecast)
            XCTAssertEqual(self.weatherUseCase.invokedDailyForecastParameters?.keywords, "foo")
            XCTAssertEqual(self.sut.forecasts, self.weatherUseCase.stubbedDailyForecastResult.forecasts)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func test_keywordsDidChange_whenNewValueIsEmpty() throws {
        let expectation = self.expectation(description: "expected the data will reload after a while")
        
        XCTAssertNil(sut.pendingReloadDatatWorkItem)
        
        sut.keywordsDidChange("")
        
        XCTAssertNotNil(sut.pendingReloadDatatWorkItem)
        
        sut.pendingReloadDatatWorkItem?.notify(queue: .main) {
            XCTAssertFalse(self.weatherUseCase.invokedDailyForecast)
            XCTAssertTrue(self.sut.forecasts.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func test_keywordsDidChange_whenNewValueIsNone() throws {
        let expectation = self.expectation(description: "expected the data will reload after a while")
        
        XCTAssertNil(sut.pendingReloadDatatWorkItem)
        
        sut.keywordsDidChange(nil)
        
        XCTAssertNotNil(sut.pendingReloadDatatWorkItem)
        
        sut.pendingReloadDatatWorkItem?.notify(queue: .main) {
            XCTAssertFalse(self.weatherUseCase.invokedDailyForecast)
            XCTAssertTrue(self.sut.forecasts.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
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

extension DailyForecastsPresenterTests {
    // MARK: Utilities
    
    private func makeWeatherUseCase() -> SpyWeatherUseCase {
        let result = SpyWeatherUseCase()
        result.stubbedDailyForecastResult = .dummy
        return result
    }
}

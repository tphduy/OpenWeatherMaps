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
    
    // MARK: Test Case - init(weatherUseCase:)
    
    func test_init() throws {
        XCTAssertIdentical(sut.weatherUseCase as! SpyWeatherUseCase, weatherUseCase)
    }
    
    // MARK: Test Case - reloadData(withKeywords:)
    
    func test_reloadDataWithKeywords_whenCacheIsMissed_andReloadedDataIsTheSame() throws {
        let reloadDataExpectation = self.expectation(description: "it will invoke weather use case to reload data")
        let presentationExpectation = self.expectation(description: "it will ask the view to show and hide loading indicator, but not to reload data")
        let cacheExpectation = self.expectation(description: "it will cache the result for later usage")
        let keywords = "foo"
        
        weatherUseCase.stubbedDailyForecastResult = DailyForecastResponse(
            city: City(
                id: 0,
                name: nil,
                country: nil,
                timezone: nil),
            forecasts: sut.forecasts)
        
        XCTAssertNil(sut.reloadDataTask)
        
        sut.reloadData(withKeywords: keywords)
        
        XCTAssertNotNil(sut.reloadDataTask)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [unowned weatherUseCase, unowned view, unowned sut] in
            XCTAssertEqual(weatherUseCase!.invokedDailyForecastCount, 1)
            XCTAssertEqual(weatherUseCase!.invokedDailyForecastParameters!.keywords, keywords)
            
            reloadDataExpectation.fulfill()
            
            XCTAssertTrue(view!.invokedShowLoading)
            XCTAssertTrue(view!.invokedHideLoading)
            XCTAssertFalse(view!.invokedReloadData)
            
            presentationExpectation.fulfill()
            
            XCTAssertEqual(sut!.cache.value(forKey: keywords), weatherUseCase?.stubbedDailyForecastResult.forecasts)
            
            cacheExpectation.fulfill()
        }
        
        wait(for: [reloadDataExpectation, presentationExpectation, cacheExpectation], timeout: 1)
    }
    
    func test_reloadDataWithKeywords_whenCacheIsMissed_andReloadedDataIsDifferent() throws {
        let reloadDataExpectation = self.expectation(description: "it will invoke weather use case to reload data")
        let presentationExpectation = self.expectation(description: "it will ask the view to show, hide loading indicator and reload data")
        let cacheExpectation = self.expectation(description: "it will cache the result for later usage")
        let keywords = "foo"
        
        XCTAssertNil(sut.reloadDataTask)
        
        sut.reloadData(withKeywords: keywords)
        
        XCTAssertNotNil(sut.reloadDataTask)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [unowned weatherUseCase, unowned view, unowned sut] in
            XCTAssertEqual(weatherUseCase!.invokedDailyForecastCount, 1)
            XCTAssertEqual(weatherUseCase!.invokedDailyForecastParameters!.keywords, keywords)
            
            reloadDataExpectation.fulfill()
            
            XCTAssertTrue(view!.invokedShowLoading)
            XCTAssertTrue(view!.invokedHideLoading)
            XCTAssertTrue(view!.invokedReloadData)
            
            presentationExpectation.fulfill()
            
            XCTAssertEqual(sut!.cache.value(forKey: keywords), weatherUseCase?.stubbedDailyForecastResult.forecasts)
            
            cacheExpectation.fulfill()
        }
        
        wait(for: [reloadDataExpectation, presentationExpectation, cacheExpectation], timeout: 1)
    }
    
    func test_reloadDataWithKeywords_whenCacheIsMissed_andEncounterError() throws {
        let reloadDataExpectation = self.expectation(description: "it will invoke weather use case to reload data")
        let presentationExpectation = self.expectation(description: "it will ask the view to show, hide loading indicator and show an error")
        let keywords = "foo"
        
        weatherUseCase.stubbedDailyForecastError = DummyError()
        
        XCTAssertNil(sut.reloadDataTask)
        
        sut.reloadData(withKeywords: keywords)
        
        XCTAssertNotNil(sut.reloadDataTask)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [unowned weatherUseCase, unowned view] in
            XCTAssertEqual(weatherUseCase!.invokedDailyForecastCount, 1)
            XCTAssertEqual(weatherUseCase!.invokedDailyForecastParameters!.keywords, keywords)
            
            reloadDataExpectation.fulfill()
            
            XCTAssertTrue(view!.invokedShowLoading)
            XCTAssertTrue(view!.invokedHideLoading)
            XCTAssertTrue(view!.invokedShowError)
            
            presentationExpectation.fulfill()
        }
        
        wait(for: [reloadDataExpectation, presentationExpectation], timeout: 1)
    }
    
    func test_reloadDataWithKeywords_whenCacheIsMissed_andEncounterError_becauseTaskWasCancelled() throws {
        let reloadDataExpectation = self.expectation(description: "it will invoke weather use case to reload data")
        let presentationExpectation = self.expectation(description: "it will ask the view to show, hide loading indicator and show an error")
        let keywords = "foo"
        
        weatherUseCase.stubbedDailyForecastError = NSError(domain: "foo", code: NSError.Code.cancelled.rawValue)
        
        XCTAssertNil(sut.reloadDataTask)
        
        sut.reloadData(withKeywords: keywords)
        
        XCTAssertNotNil(sut.reloadDataTask)
        
        sut.reloadDataTask?.cancel()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [unowned weatherUseCase, unowned view] in
            XCTAssertEqual(weatherUseCase!.invokedDailyForecastCount, 1)
            XCTAssertEqual(weatherUseCase!.invokedDailyForecastParameters!.keywords, keywords)
            
            reloadDataExpectation.fulfill()
            
            XCTAssertTrue(view!.invokedShowLoading)
            XCTAssertTrue(view!.invokedHideLoading)
            XCTAssertFalse(view!.invokedShowError)
            
            presentationExpectation.fulfill()
        }
        
        wait(for: [reloadDataExpectation, presentationExpectation], timeout: 1)
    }
    
    func test_reloadDataWithKeywords_whenCacheIsHit_andCacheDataIsTheSame() throws {
        let expectation = self.expectation(description: "it will not ask the view to reload data")
        let keywords = "foo"
        
        sut.cache.insert(sut.forecasts, forKey: keywords)
        
        XCTAssertNil(sut.reloadDataTask)
        
        sut.reloadData(withKeywords: keywords)
        
        XCTAssertNil(sut.reloadDataTask)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [unowned view] in
            XCTAssertFalse(view!.invokedReloadData)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_reloadDataWithKeywords_whenCacheIsHit_andCacheDataIsDifferent() throws {
        let expectation = self.expectation(description: "it will ask the view to reload data")
        let forecasts = [Forecast.dummy]
        let keywords = "foo"
        
        sut.cache.insert(forecasts, forKey: keywords)
        
        XCTAssertNil(sut.reloadDataTask)
        
        sut.reloadData(withKeywords: keywords)
        
        XCTAssertNil(sut.reloadDataTask)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [unowned view, unowned sut] in
            XCTAssertTrue(view!.invokedReloadData)
            XCTAssertEqual(sut!.forecasts, forecasts)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    // MARK: Test Case - viewDidLoad()

    func test_viewDidLoad() throws {
        XCTAssertNoThrow(sut.viewDidLoad())
    }

    // MARK: Test Case - viewDidAppear()

    func test_viewDidAppear_whenDataIsEmpty() throws {
        sut.viewDidAppear()

        XCTAssertTrue(view.invokedStartEditing)
    }

    func test_viewDidAppear_whenDataIsSome() throws {
        sut = DailyForecastsPresenter(weatherUseCase: weatherUseCase, forecasts: [.dummy])

        sut.viewDidAppear()

        XCTAssertFalse(view.invokedStartEditing)
    }

    // MARK: Test Case - keywordsDidChange(_:)
    
    func test_keywordsDidChange_whenNewKeywordsAreTheSame() throws {
        sut.keywordsDidChange(sut.lastKeywords)
        
        XCTAssertNil(sut.pendingReloadDatatWorkItem)
    }
    
    func test_keywordsDidChange_whenNewKeywordsAreDifferent() throws {
        let expectation = self.expectation(description: "the data will be reload after a while")
        let keywords = "foo"
        
        XCTAssertNotEqual(sut.lastKeywords, keywords)
        
        sut.keywordsDidChange(keywords)
        
        XCTAssertEqual(sut.lastKeywords, keywords)
        
        sut.pendingReloadDatatWorkItem?.notify(queue: .main) { [unowned weatherUseCase] in
            XCTAssertTrue(weatherUseCase!.invokedDailyForecast)
            XCTAssertEqual(weatherUseCase!.invokedDailyForecastParameters!.keywords, keywords)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_keywordsDidChange_whenNewKeywordsAreDifferent_andLessThanThreeCharacters() throws {
        let expectation = self.expectation(description: "the data will be empty without reload-data request")
        let keywords = "f"
        
        XCTAssertNotEqual(sut.lastKeywords, keywords)
        
        sut.keywordsDidChange(keywords)
        
        XCTAssertEqual(sut.lastKeywords, keywords)
        
        sut.pendingReloadDatatWorkItem?.notify(queue: .main) { [unowned weatherUseCase, unowned sut] in
            XCTAssertFalse(weatherUseCase!.invokedDailyForecast)
            XCTAssertEqual(sut!.forecasts, [])
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_keywordsDidChange_whenNewKeywordsAreDifferent_andBeingInvokedMultipleTimes() throws {
        let expectation = self.expectation(description: "expected the data will be reload after a while")
        let firstKeywords = "foo"
        let secondKeywords = "bar"

        XCTAssertNotEqual(sut.lastKeywords, firstKeywords)

        sut.keywordsDidChange(firstKeywords)

        XCTAssertEqual(sut.lastKeywords, firstKeywords)

        let pendingReloadDatatWorkItem = sut.pendingReloadDatatWorkItem

        sut.keywordsDidChange(secondKeywords)

        XCTAssertEqual(sut.lastKeywords, secondKeywords)

        XCTAssertNotIdentical(sut.pendingReloadDatatWorkItem, pendingReloadDatatWorkItem)

        sut.pendingReloadDatatWorkItem?.notify(queue: .main) { [unowned weatherUseCase] in
            XCTAssertEqual(weatherUseCase!.invokedDailyForecastCount, 1)
            XCTAssertEqual(weatherUseCase!.invokedDailyForecastParameters?.keywords, secondKeywords)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
    
    // MARK: Test Case - numberOfSections()
    
    func test_numberOfSections_whenDataIsEmpty() throws {
        XCTAssertEqual(sut.numberOfSections(), 0)
    }
    
    func test_numberOfSections_whenDataIsSome() throws {
        sut = DailyForecastsPresenter(weatherUseCase: weatherUseCase, forecasts: [.dummy])
        
        XCTAssertEqual(sut.numberOfSections(), 1)
    }
    
    // MARK: Test Case - numberOfItems(in:)
    
    func test_numberOfItems_whenDataIsEmpty() throws {
        XCTAssertEqual(sut.numberOfItems(in: 0), 0)
    }
    
    func test_numberOfItems_whenDataIsSome() throws {
        sut = DailyForecastsPresenter(weatherUseCase: weatherUseCase, forecasts: [.dummy])
        
        XCTAssertEqual(sut.numberOfItems(in: 0), 1)
    }
    
    // MARK: Test Case - item(at:)
    
    func test_itemAtIndexPath() throws {
        let forecast = Forecast.dummy
        
        sut = DailyForecastsPresenter(weatherUseCase: weatherUseCase, forecasts: [forecast])
        
        XCTAssertEqual(sut.item(at: IndexPath(item: 0, section: 0)), forecast)
    }
}

extension DailyForecastsPresenterTests {
    // MARK: Utilities
    
    private func makeWeatherUseCase() -> SpyWeatherUseCase {
        let result = SpyWeatherUseCase()
        result.stubbedDailyForecastResult = .dummy
        return result
    }
}

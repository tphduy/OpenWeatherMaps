//
//  DailyForecastsBuilderTests.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Trần on 20/07/2022.
//

import XCTest
@testable import OpenWeatherMaps

final class DailyForecastsBuilderTests: XCTestCase {
    // MARK: Misc
    
    private var listener: SpyDailyForecastsListener!
    private var weatherUseCase: SpyWeatherUseCase!
    private var sut: DailyForecastsBuilder!
    
    // MARK: Life Cycle

    override func setUpWithError() throws {
        listener = SpyDailyForecastsListener()
        weatherUseCase = SpyWeatherUseCase()
        sut = DailyForecastsBuilder()
        sut.weatherUseCase = weatherUseCase
    }

    override func tearDownWithError() throws {
        listener = nil
        weatherUseCase = nil
        sut = nil
    }
    
     // MARK: Test Cases - build(listener:)
    
    func test_build() throws {
        let viewController = sut.build(listener: listener) as! DailyForecastsViewController
        let presenter = viewController.presenter as! DailyForecastsPresenter
        XCTAssertIdentical(presenter.view, viewController)
        XCTAssertIdentical(presenter.coordinator, viewController)
        XCTAssertIdentical(presenter.listener, listener)
        XCTAssertIdentical(presenter.weatherUseCase as! SpyWeatherUseCase, weatherUseCase)
    }
}

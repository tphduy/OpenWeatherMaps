//
//  DefaultRemoteWeatherRepositoryTests.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Tran on 23/06/2022.
//

import XCTest
import Networkable
@testable import OpenWeatherMaps

final class DefaultRemoteWeatherRepositoryTests: XCTestCase {
    // MARK: Misc
    
    var provider: SpyWebRepository!
    var sut: DefaultRemoteWeatherRepository!
    
    // MARK: Life Cycle
    
    override func setUpWithError() throws {
        provider = SpyWebRepository()
        sut = DefaultRemoteWeatherRepository(provider: provider)
    }
    
    override func tearDownWithError() throws {
        provider = nil
        sut = nil
    }
    
    // MARK: Test Cases
    
    func test_dailyForecast() async throws {
        let response = makeDailyForecastResponse()
        provider.stubbedCallResult = response
        XCTAssertFalse(provider.invokedCall)
        let result = try await sut.dailyForecast(keyword: "foo", numberOfDays: 1)
        XCTAssertTrue(provider.invokedCall)
        XCTAssertEqual(result, response)
    }
    
    func test_dailyForecast_whenThrowingError() async throws {
        let stubbedError = DummyError()
        provider.stubbedCallError = stubbedError
        XCTAssertFalse(provider.invokedCall)
        do {
            let _ = try await sut.dailyForecast(keyword: "foo", numberOfDays: 1)
            XCTExpectFailure("Expected to throw an error.")
        } catch {
            XCTAssertEqual(error as! DummyError, stubbedError)
        }
        XCTAssertTrue(provider.invokedCall)
    }
}

extension DefaultRemoteWeatherRepositoryTests {
    // MARK: Utilities
    
    private func makeCity() -> City {
        City(
            id: 0,
            name: "name",
            country: "country",
            timezone: 0)
    }
    
    private func makeDailyForecastResponse() -> DailyForecastResponse {
        DailyForecastResponse(
            city: makeCity(),
            forecasts: [])
    }
}

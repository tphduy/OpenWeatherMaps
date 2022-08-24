//
//  DefaultRemoteWeatherRepository+APIEndpoint+Tests.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Tran on 23/06/2022.
//

import XCTest
import Networkable
@testable import OpenWeatherMaps

final class DefaultRemoteWeatherRepository_APIEndpoint_Tests: XCTestCase {
    // MARK: Misc
    
    private var sut: DefaultRemoteWeatherRepository.APIEndpoint!
    
    // MARK: Life Cycle

    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: Test Cases - dailyForecast
    
    func test_dailyForecast_headers() throws {
        sut = makeDailyForecast()
        XCTAssertNil(sut.headers)
    }
    
    func test_dailyForecast_URL() throws {
        sut = makeDailyForecast()
        XCTAssertEqual(sut.url, "/data/2.5/forecast/daily?q=foo&cnt=1")
    }
    
    func test_dailyForecast_method() throws {
        sut = makeDailyForecast()
        XCTAssertEqual(sut.method, .get)
    }
    
    func test_dailyForecast_body() throws {
        sut = makeDailyForecast()
        XCTAssertNoThrow(try sut.body())
        XCTAssertNil(try! sut.body())
    }
}

extension DefaultRemoteWeatherRepository_APIEndpoint_Tests {
    // MARK: Utilities
    
    private func makeDailyForecast(keywords: String = "foo", numberOfDays: Int = 1) -> DefaultRemoteWeatherRepository.APIEndpoint {
        .dailyForecast(keywords: keywords, numberOfDays: numberOfDays)
    }
}

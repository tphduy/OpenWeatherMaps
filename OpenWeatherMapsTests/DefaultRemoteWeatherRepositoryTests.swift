//
//  DefaultRemoteWeatherRepositoryTests.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Trần on 01/10/2022.
//

import XCTest
@testable import OpenWeatherMaps

final class DefaultRemoteWeatherRepositoryTests: XCTestCase {
    // MARK: Misc
    
    private var session: SpyNetworkableSession!
    private var sut: DefaultRemoteWeatherRepository!
    
    // MARK: Life Cycle
    
    override func setUpWithError() throws {
        session = makeSession()
        sut = DefaultRemoteWeatherRepository(session: session)
    }

    override func tearDownWithError() throws {
        session = nil
        sut = nil
    }

    // MARK: Test Cases - dailyForecast(keywords:numberOfDays:)
    
    func test_dailyForecast() async throws {
        let keywords = "foo"
        let numberOfDays = 1
        
        let _ = try await sut.dailyForecast(keywords: keywords, numberOfDays: numberOfDays)
    }
}

extension DefaultRemoteWeatherRepositoryTests {
    // MARK: Utilities
    
    private func makeSession() -> SpyNetworkableSession {
        let result = SpyNetworkableSession()
        result.stubbedDataForResult = DailyForecastResponse.dummy
        return result
    }
}

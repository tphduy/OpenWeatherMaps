//
//  DefaultWeatherUseCaseTests.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Tran on 23/06/2022.
//

import XCTest
@testable import OpenWeatherMaps

final class DefaultWeatherUseCaseTests: XCTestCase {
    // MARK: Misc
    
    private var remoteWeatherRepository: SpyRemoteWeatherRepository!
    private var sut: DefaultWeatherUseCase!
    
    // MARK: Life Cycle
    
    override func setUpWithError() throws {
        remoteWeatherRepository = SpyRemoteWeatherRepository()
        sut = DefaultWeatherUseCase(remoteWeatherRepository: remoteWeatherRepository)
    }

    override func tearDownWithError() throws {
        remoteWeatherRepository = nil
        sut = nil
    }
    
    // MARK: Test Cases - `dailyForecast(keyword:numberOfDays:)`

    func test_dailyForecast() async throws {
        let response = DailyForecastResponse.dummy
        remoteWeatherRepository.stubbedDailyForecastResult = response
        XCTAssertFalse(remoteWeatherRepository.invokedDailyForecast)
        let result = try await sut.dailyForecast(keywords: "foo", numberOfDays: 1)
        XCTAssertTrue(remoteWeatherRepository.invokedDailyForecast)
        XCTAssertEqual(result, response)
    }
    
    func test_dailyForecast_whenRemoteRepositoryThrowsError() async throws {
        let stubbedError = DummyError()
        remoteWeatherRepository.stubbedDailyForecastError = stubbedError
        XCTAssertFalse(remoteWeatherRepository.invokedDailyForecast)
        do {
            let _ = try await sut.dailyForecast(keywords: "foo", numberOfDays: 1)
            XCTFail("Expected to throw an error.")
        } catch {
            XCTAssertEqual(error as! DummyError, stubbedError)
        }
        XCTAssertTrue(remoteWeatherRepository.invokedDailyForecast)
    }
}

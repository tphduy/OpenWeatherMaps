//
//  DefaultWeatherUseCaseTests.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Trần on 01/10/2022.
//

import XCTest
@testable import OpenWeatherMaps

final class DefaultWeatherUseCaseTests: XCTestCase {
    // MARK: Misc
    
    private var remoteWeatherRepository: SpyRemoteWeatherRepository!
    private var sut: DefaultWeatherUseCase!
    
    // MARK: Life Cycle
    
    override func setUpWithError() throws {
        remoteWeatherRepository = makeRemoteWeatherRepository()
        sut = DefaultWeatherUseCase(remoteWeatherRepository: remoteWeatherRepository)
    }

    override func tearDownWithError() throws {
        remoteWeatherRepository = nil
        sut = nil
    }
    
    // MARK: Test Cases - dailyForecast(keywords:numberOfDays:)
    
    func test_dailyForecast() async throws {
        let keywords = "foo"
        let numberOfDays = 1
        
        let result = try await sut.dailyForecast(keywords: keywords, numberOfDays: numberOfDays)
        
        XCTAssertEqual(result, remoteWeatherRepository.stubbedDailyForecastResult)
        XCTAssertTrue(remoteWeatherRepository.invokedDailyForecast)
        XCTAssertEqual(remoteWeatherRepository.invokedDailyForecastParameters?.keywords, keywords)
        XCTAssertEqual(remoteWeatherRepository.invokedDailyForecastParameters?.numberOfDays, numberOfDays)
    }
    
    func test_dailyForecast_whenRemoteWeatherRepositoryThrowsError() async throws {
        let keywords = "foo"
        let numberOfDays = 1
        let dummyError = DummyError()
        remoteWeatherRepository.stubbedDailyForecastError = dummyError
        
        do {
            let _ = try await sut.dailyForecast(keywords: keywords, numberOfDays: numberOfDays)
            XCTFail("it should encounter an error.")
        } catch {
            XCTAssertEqual(error as! DummyError, dummyError)
            XCTAssertTrue(remoteWeatherRepository.invokedDailyForecast)
            XCTAssertEqual(remoteWeatherRepository.invokedDailyForecastParameters?.keywords, keywords)
            XCTAssertEqual(remoteWeatherRepository.invokedDailyForecastParameters?.numberOfDays, numberOfDays)
        }
    }
}

extension DefaultWeatherUseCaseTests {
    // MARK: Utilities
    
    private func makeRemoteWeatherRepository() -> SpyRemoteWeatherRepository {
        let result = SpyRemoteWeatherRepository()
        result.stubbedDailyForecastResult = .dummy
        return result
    }
}

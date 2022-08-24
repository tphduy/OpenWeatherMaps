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
    
    private var provider: SpyWebRepository!
    private var sut: DefaultRemoteWeatherRepository!
    
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
        
        let result = try await sut.dailyForecast(keywords: "foo", numberOfDays: 1)
        
        XCTAssertTrue(provider.invokedCall)
        XCTAssertEqual(result, response)
    }

    func test_dailyForecast_whenThrowingError() async throws {
        let stubbedError = DummyError()
        provider.stubbedCallError = stubbedError
        
        do {
            let _ = try await sut.dailyForecast(keywords: "foo", numberOfDays: 1)
            XCTFail("Expected to throw an error.")
        } catch {
            XCTAssertEqual(error as! DummyError, stubbedError)
        }
        
        XCTAssertTrue(provider.invokedCall)
    }
    
    func test_dailyForecast_whenThrowingNetworkableError_andDataIsEmpty() async throws {
        let stubbedError = NetworkableError.unacceptableStatusCode(makeResponse(), Data())
        provider.stubbedCallError = stubbedError
        
        do {
            let _ = try await sut.dailyForecast(keywords: "foo", numberOfDays: 1)
            XCTFail("Expected to throw an error.")
        } catch {
            XCTAssertEqual(error as! NetworkableError, stubbedError)
        }
        
        XCTAssertTrue(provider.invokedCall)
    }
    
    func test_dailyForecast_whenThrowingNetworkableError_andDataIsParsableToOpenWeatherMapsError() async throws {
        let underlyingError = OpenWeatherMapsError(message: "foo")
        let data = try! JSONEncoder().encode(underlyingError)
        let stubbedError = NetworkableError.unacceptableStatusCode(makeResponse(), data)
        provider.stubbedCallError = stubbedError
        
        do {
            let _ = try await sut.dailyForecast(keywords: "foo", numberOfDays: 1)
            XCTFail("Expected to throw an error.")
        } catch {
            XCTAssertEqual(error as! OpenWeatherMapsError, underlyingError)
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
    
    private func makeResponse() -> HTTPURLResponse {
        HTTPURLResponse(
            url: URL(string: "https://foo.bar")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)!
    }
}

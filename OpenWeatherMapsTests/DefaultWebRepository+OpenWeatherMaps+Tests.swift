//
//  DefaultWebRepository+OpenWeatherMaps+Tests.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Tran on 23/06/2022.
//

import XCTest
import Networkable
@testable import OpenWeatherMaps

final class DefaultWebRepository_OpenWeatherMaps_Tests: XCTestCase {
    // MARK: Misc
    
    var sut: DefaultWebRepository!
    
    // MARK: Life Cycle
    
    override func setUpWithError() throws {
        sut = .openWeatherMaps
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: Test Cases
    
    func test_init() {
        XCTAssertEqual(sut.requestBuilder.baseURL, URL(string: Natrium.Config.openWeatherMapURL))
        XCTAssertTrue(sut.middlewares.contains(where: { $0 is AuthorizationMiddleware }))
        XCTAssertTrue(sut.middlewares.contains(where: { $0 is LocalizationMiddleware }))
        XCTAssertTrue(sut.middlewares.contains(where: { $0 is StatusCodeValidationMiddleware }))
        XCTAssertTrue(sut.middlewares.contains(where: { $0 is LoggingMiddleware }))
    }
}

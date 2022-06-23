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
        XCTAssertTrue(sut.middlewares.contains(where: { $0 is LoggingMiddleware }))
        let authorizationMiddleware = sut.middlewares.first(where: { $0 is AuthorizationMiddleware }) as! AuthorizationMiddleware
        XCTAssertNotNil(authorizationMiddleware)
        XCTAssertEqual(authorizationMiddleware.key, "appid")
        XCTAssertEqual(authorizationMiddleware.value, Natrium.Config.appID)
        XCTAssertEqual(authorizationMiddleware.place, .query)
    }
}

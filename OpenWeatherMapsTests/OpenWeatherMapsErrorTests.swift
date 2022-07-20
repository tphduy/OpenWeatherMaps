//
//  OpenWeatherMapsErrorTests.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Trần on 21/07/2022.
//

import XCTest
@testable import OpenWeatherMaps

final class OpenWeatherMapsErrorTests: XCTestCase {
    // MARK: Misc
    
    private var sut: OpenWeatherMapsError!
    
    // MARK: Life Cycle

    override func setUpWithError() throws {
        sut = OpenWeatherMapsError(message: "foo")
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
     // MARK: Test Cases - errorDescription
    
    func test_errorDescription() throws {
        XCTAssertEqual(sut.errorDescription, sut.message)
    }
}

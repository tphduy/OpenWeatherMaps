//
//  OpenWeatherMapsUITests.swift
//  OpenWeatherMapsUITests
//
//  Created by Duy Tran on 22/06/2022.
//

import XCTest

final class OpenWeatherMapsUITests: XCTestCase {
    // MARK: Life Cycle
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    // MARK: Test Cases

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }

    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}

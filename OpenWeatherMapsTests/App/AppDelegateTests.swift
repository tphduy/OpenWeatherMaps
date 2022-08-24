//
//  AppDelegateTests.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Trần on 24/08/2022.
//

import XCTest
@testable import OpenWeatherMaps

final class AppDelegateTests: XCTestCase {
    // MARK: Misc
    
    var application: UIApplication!
    var sut: AppDelegate!
    
    // MARK: Life Cycle
    
    override func setUpWithError() throws {
        application = .shared
        sut = AppDelegate()
    }

    override func tearDownWithError() throws {
        application = nil
        sut = nil
    }
    
    // MARK: Test Cases

    func testExample() throws {
        XCTAssertTrue(sut.application(application, didFinishLaunchingWithOptions: [:]))
    }
}

//
//  SceneDelegateTests.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Trần on 01/10/2022.
//

import XCTest
@testable import OpenWeatherMaps

final class SceneDelegateTests: XCTestCase {
    // MARK: Misc
    
    private var sut: SceneDelegate!
    
    // MARK: Life Cycle
    
    override func setUpWithError() throws {
        sut = SceneDelegate()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
}

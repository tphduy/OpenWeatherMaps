//
//  ForecastCollectionViewCellTests.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Tran on 25/06/2022.
//

import XCTest
@testable import OpenWeatherMaps

final class ForecastCollectionViewCellTests: XCTestCase {
    // MARK: Misc
    
    private var sut: ForecastCollectionViewCell!
    
    // MARK: Life Cycle

    override func setUpWithError() throws {
        sut = ForecastCollectionViewCell()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: Test Case - configure(withForecast:)
    
    func test_configureWithForecast() throws {
        sut.configure(withForecast: .dummy)
    }
}

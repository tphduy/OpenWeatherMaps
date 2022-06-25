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
    
    private var dateFormatter: DateFormatter!
    private var sut: ForecastCollectionViewCell!
    
    // MARK: Life Cycle

    override func setUpWithError() throws {
        dateFormatter = makeDateFormatter()
        sut = ForecastCollectionViewCell()
    }

    override func tearDownWithError() throws {
        dateFormatter = nil
        sut = nil
    }
    
    // MARK: Test Case - setupLayout()
    
    func test_setupLayout() throws {
        XCTAssertTrue(sut.masterStackView.isDescendant(of: sut.contentView))
    }
    
    // MARK: Test Case - configure(withForecast:)
    
    func test_configureWithForecast() throws {
        let forecast = Forecast.dummy
        
        sut.configure(withForecast: forecast, dateFormatter: dateFormatter)
        
        XCTAssertEqual(sut.dateLabel.text, dateFormatter.string(from: forecast.date))
    }
}

extension ForecastCollectionViewCellTests {
    // MARK: Utilities
    
    private func makeDateFormatter() -> DateFormatter {
        let result = DateFormatter()
        result.dateStyle = .short
        result.timeStyle = .none
        return result
    }
}

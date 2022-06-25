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
    
    private var forecast: Forecast!
    private var dateFormatter: DateFormatter!
    private var imageURLFactory: ImageURLFactory!
    private var sut: ForecastCollectionViewCell!
    
    // MARK: Life Cycle

    override func setUpWithError() throws {
        forecast = Forecast(
            date: Date(),
            temperature: Temperature(min: 0, max: 10),
            pressure: 1,
            humidity: 1,
            weather: [Forecast.Weather(
                main: "Clear",
                desc: "sky is clear",
                icon: "icon")])
        dateFormatter = makeDateFormatter()
        imageURLFactory = ImageURLFactory(baseURL: "https://foo.bar")
        sut = ForecastCollectionViewCell()
    }

    override func tearDownWithError() throws {
        forecast = nil
        dateFormatter = nil
        sut = nil
    }
    
    // MARK: Test Case - setupLayout()
    
    func test_setupLayout() throws {
        XCTAssertTrue(sut.masterStackView.isDescendant(of: sut.contentView))
    }
    
    // MARK: Test Case - configure(withForecast:)
    
    func test_configureWithForecast() throws {
        let dateFormat = NSLocalizedString("Date: %@", comment: "Date: %@")
        let date = String(format: dateFormat, dateFormatter.string(from: forecast.date))
        let averageTemperatureFormat = NSLocalizedString("Average Temperature: %d", comment: "Average Temperature: %d")
        let averageTemperature = String(format: averageTemperatureFormat, 5)
        let pressureFormat = NSLocalizedString("Pressure: %d", comment: "Pressure: %d")
        let pressure = String(format: pressureFormat, 1)
        let humidityFormat = NSLocalizedString("Humidity: %d", comment: "Humidity: %d")
        let humidity = String(format: humidityFormat, 1)
        let descriptionFormat = NSLocalizedString("Description: %@", comment: "Description: %@")
        let description = String(format: descriptionFormat, "sky is clear")
        
        sut.configure(withForecast: forecast, dateFormatter: dateFormatter, imageURLFactory: imageURLFactory)
        
        XCTAssertEqual(sut.dateLabel.text, date)
        XCTAssertFalse(sut.dateLabel.isHidden)
        XCTAssertEqual(sut.averageTemperatureLabel.text, averageTemperature)
        XCTAssertFalse(sut.averageTemperatureLabel.isHidden)
        XCTAssertEqual(sut.pressureLabel.text, pressure)
        XCTAssertFalse(sut.pressureLabel.isHidden)
        XCTAssertEqual(sut.humidityLabel.text, humidity)
        XCTAssertFalse(sut.humidityLabel.isHidden)
        XCTAssertEqual(sut.descriptionLabel.text, description)
        XCTAssertFalse(sut.descriptionLabel.isHidden)
        XCTAssertFalse(sut.iconImageView.isHidden)
    }
    
    func test_configureWithForecast_whenDateIsNone() throws {
        let forecast = Forecast(
            date: Date(),
            temperature: nil,
            pressure: nil,
            humidity: nil,
            weather: nil)
        
        sut.configure(withForecast: forecast, dateFormatter: dateFormatter, imageURLFactory: imageURLFactory)
        
        XCTAssertEqual(sut.averageTemperatureLabel.text, "")
        XCTAssertTrue(sut.averageTemperatureLabel.isHidden)
        XCTAssertEqual(sut.pressureLabel.text, "")
        XCTAssertTrue(sut.pressureLabel.isHidden)
        XCTAssertEqual(sut.humidityLabel.text, "")
        XCTAssertTrue(sut.humidityLabel.isHidden)
        XCTAssertEqual(sut.descriptionLabel.text, "")
        XCTAssertTrue(sut.descriptionLabel.isHidden)
        XCTAssertTrue(sut.iconImageView.isHidden)
    }
    
    func test_configureWithForecast_whenMinimumTemperatureIsNone() throws {
        let format = NSLocalizedString("Average Temperature: %d", comment: "Average Temperature: %d")
        let averageTemperature = String(format: format, 10)
        let forecast = Forecast(
            date: Date(),
            temperature: Temperature(min: nil, max: 10),
            pressure: nil,
            humidity: nil,
            weather: nil)
        
        sut.configure(withForecast: forecast, dateFormatter: dateFormatter, imageURLFactory: imageURLFactory)
        
        XCTAssertEqual(sut.averageTemperatureLabel.text, averageTemperature)
        XCTAssertFalse(sut.averageTemperatureLabel.isHidden)
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

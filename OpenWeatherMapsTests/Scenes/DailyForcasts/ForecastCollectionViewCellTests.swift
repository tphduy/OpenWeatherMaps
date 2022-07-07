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
    private var measurementFormatter: MeasurementFormatter!
    private var imageURLFactory: ImageURLFactory!
    private var sut: ForecastCollectionViewCell!
    
    // MARK: Life Cycle

    override func setUpWithError() throws {
        forecast = makeForecast()
        dateFormatter = makeDateFormatter()
        measurementFormatter = makeMeasurementFormatter()
        imageURLFactory = ImageURLFactory(baseURL: "https://foo.bar")
        sut = ForecastCollectionViewCell()
    }

    override func tearDownWithError() throws {
        forecast = nil
        dateFormatter = nil
        measurementFormatter = nil
        imageURLFactory = nil
        sut = nil
    }
    
    // MARK: Test Case - prepareForReuse()
    
    func test_prepareForReuse() throws {
        sut.iconImageView.kf.setImage(with: URL(string: "https://foo.bar/image.jpg"))
        XCTAssertNotNil(sut.iconImageView.kf.taskIdentifier)
        sut.prepareForReuse()
        XCTAssertNil(sut.iconImageView.kf.taskIdentifier)
    }
    
    // MARK: Test Case - setupLayout()
    
    func test_setupLayout() throws {
        XCTAssertTrue(sut.masterStackView.isDescendant(of: sut.contentView))
        XCTAssertFalse(sut.masterStackView.constraints.isEmpty)
    }
    
    // MARK: Test Case - configure(withForecast:dateFormatter:measurementFormatter:imageURLFactory)
    
    func test_configureWithForecast_whenDateIsSome() throws {
        let text = dateFormatter.string(from: Date(timeIntervalSince1970: forecast.date!))
        let format = NSLocalizedString("Date: %@", comment: "Date: %@")
        let expected = String(format: format, text)
        
        sut.configure(
            withForecast: forecast,
            dateFormatter: dateFormatter,
            measurementFormatter: measurementFormatter,
            imageURLFactory: imageURLFactory)
        
        XCTAssertEqual(sut.dateLabel.text, expected)
        XCTAssertFalse(sut.dateLabel.isHidden)
    }
    
    func test_configureWithForecast_whenDateIsNone() throws {
        forecast = makeEmptyForecast()
        
        sut.configure(
            withForecast: forecast,
            dateFormatter: dateFormatter,
            measurementFormatter: measurementFormatter,
            imageURLFactory: imageURLFactory)
        
        XCTAssertEqual(sut.dateLabel.text, "")
        XCTAssertTrue(sut.dateLabel.isHidden)
    }
    
    func test_configureWithForecast_whenTemperatureIsSome() throws {
        let averageTemperature = (forecast.temperature!.min! + forecast.temperature!.max!) / 2
        let measurement = Measurement<UnitTemperature>(value: averageTemperature, unit: .kelvin)
        let text = measurementFormatter.string(from: measurement)
        let format = NSLocalizedString("Average Temperature: %@", comment: "Average Temperature: %@")
        let expected = String(format: format, text)
        
        sut.configure(
            withForecast: forecast,
            dateFormatter: dateFormatter,
            measurementFormatter: measurementFormatter,
            imageURLFactory: imageURLFactory)
        
        XCTAssertEqual(sut.averageTemperatureLabel.text, expected)
        XCTAssertFalse(sut.averageTemperatureLabel.isHidden)
    }
    
    func test_configureWithForecast_whenTemperatureIsNone() throws {
        forecast = makeEmptyForecast()
        
        sut.configure(
            withForecast: forecast,
            dateFormatter: dateFormatter,
            measurementFormatter: measurementFormatter,
            imageURLFactory: imageURLFactory)
        
        XCTAssertEqual(sut.averageTemperatureLabel.text, "")
        XCTAssertTrue(sut.averageTemperatureLabel.isHidden)
    }
    
    func test_configureWithForecast_whenPressureIsSome() throws {
        let measurement = Measurement<UnitPressure>(value: forecast.pressure!, unit: .hectopascals)
        let text = measurementFormatter.string(from: measurement)
        let format = NSLocalizedString("Pressure: %@", comment: "Pressure: %@")
        let expected = String(format: format, text)
        
        sut.configure(
            withForecast: forecast,
            dateFormatter: dateFormatter,
            measurementFormatter: measurementFormatter,
            imageURLFactory: imageURLFactory)
        
        XCTAssertEqual(sut.pressureLabel.text, expected)
        XCTAssertFalse(sut.pressureLabel.isHidden)
    }
    
    func test_configureWithForecast_whenPressureIsNone() throws {
        forecast = makeEmptyForecast()
        
        sut.configure(
            withForecast: forecast,
            dateFormatter: dateFormatter,
            measurementFormatter: measurementFormatter,
            imageURLFactory: imageURLFactory)
        
        XCTAssertEqual(sut.pressureLabel.text, "")
        XCTAssertTrue(sut.pressureLabel.isHidden)
    }
    
    func test_configureWithForecast_whenHumidityIsSome() throws {
        let text = "\(Int(forecast.humidity!))%"
        let format = NSLocalizedString("Humidity: %@", comment: "Humidity: %@")
        let expected = String(format: format, text)
        
        sut.configure(
            withForecast: forecast,
            dateFormatter: dateFormatter,
            measurementFormatter: measurementFormatter,
            imageURLFactory: imageURLFactory)
        
        XCTAssertEqual(sut.humidityLabel.text, expected)
        XCTAssertFalse(sut.humidityLabel.isHidden)
    }
    
    func test_configureWithForecast_whenHumidityIsNone() throws {
        forecast = makeEmptyForecast()
        
        sut.configure(
            withForecast: forecast,
            dateFormatter: dateFormatter,
            measurementFormatter: measurementFormatter,
            imageURLFactory: imageURLFactory)
        
        XCTAssertEqual(sut.humidityLabel.text, "")
        XCTAssertTrue(sut.humidityLabel.isHidden)
    }
    
    func test_configureWithForecast_whenDescriptionIsSome() throws {
        let text = forecast.weather![0].desc!
        let format = NSLocalizedString("Description: %@", comment: "Description: %@")
        let expected = String(format: format, text)
        
        sut.configure(
            withForecast: forecast,
            dateFormatter: dateFormatter,
            measurementFormatter: measurementFormatter,
            imageURLFactory: imageURLFactory)
        
        XCTAssertEqual(sut.descriptionLabel.text, expected)
        XCTAssertFalse(sut.descriptionLabel.isHidden)
    }
    
    func test_configureWithForecast_whenDescriptionIsNone() throws {
        forecast = makeEmptyForecast()
        
        sut.configure(
            withForecast: forecast,
            dateFormatter: dateFormatter,
            measurementFormatter: measurementFormatter,
            imageURLFactory: imageURLFactory)
        
        XCTAssertEqual(sut.descriptionLabel.text, "")
        XCTAssertTrue(sut.descriptionLabel.isHidden)
    }
    
    func test_configureWithForecast_whenIconIsSome() throws {
        sut.configure(
            withForecast: forecast,
            dateFormatter: dateFormatter,
            measurementFormatter: measurementFormatter,
            imageURLFactory: imageURLFactory)
        
        XCTAssertNotNil(sut.iconImageView.kf.taskIdentifier)
        XCTAssertFalse(sut.iconImageView.isHidden)
    }
    
    func test_configureWithForecast_whenIconIsNone() throws {
        forecast = makeEmptyForecast()
        
        sut.configure(
            withForecast: forecast,
            dateFormatter: dateFormatter,
            measurementFormatter: measurementFormatter,
            imageURLFactory: imageURLFactory)
        
        XCTAssertNil(sut.iconImageView.kf.taskIdentifier)
        XCTAssertTrue(sut.iconImageView.isHidden)
    }
}

extension ForecastCollectionViewCellTests {
    // MARK: Utilities
    
    private func makeEmptyForecast() -> Forecast {
        Forecast(
            date: nil,
            temperature: nil,
            pressure: nil,
            humidity: nil,
            weather: nil)
    }
    
    private func makeForecast() -> Forecast {
        Forecast(
            date: 0,
            temperature: Temperature(min: 0, max: 10),
            pressure: 1,
            humidity: 1,
            weather: [
                Forecast.Weather(
                main: "Clear",
                desc: "sky is clear",
                icon: "clear"),
                Forecast.Weather(
                main: "Foo",
                desc: "foo bar",
                icon: "foo"),
            ])
    }
    
    private func makeDateFormatter() -> DateFormatter {
        let result = DateFormatter()
        result.dateStyle = .short
        result.timeStyle = .short
        return result
    }
    
    private func makeMeasurementFormatter() -> MeasurementFormatter {
        let result = MeasurementFormatter()
        result.unitStyle = .short
        return result
    }
}

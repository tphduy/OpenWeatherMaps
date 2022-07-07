//
//  ForecastCollectionViewCell.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 25/06/2022.
//

import UIKit
import Kingfisher

/// A collection view cell that displays a forecast.
final class ForecastCollectionViewCell: UICollectionViewCell {
    // MARK: Uis
    
    /// A label that displays the date a forecase was publised.
    private(set) lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .preferredFont(forTextStyle: .body)
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A label that displays the averate temperature of a day.
    private(set) lazy var averageTemperatureLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .preferredFont(forTextStyle: .body)
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A label that displays the pressure.
    private(set) lazy var pressureLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .preferredFont(forTextStyle: .body)
        view.adjustsFontForContentSizeCategory = true
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A label that displays the humidity.
    private(set) lazy var humidityLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .preferredFont(forTextStyle: .body)
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A label that displays the description.
    private(set) lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .preferredFont(forTextStyle: .body)
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A vertical stack view at the leading that contains all informative labels.
    private(set) lazy var leadingStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            dateLabel,
            averageTemperatureLabel,
            pressureLabel,
            humidityLabel,
            descriptionLabel,
        ])
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// An image view that displays an icon of a weather.
    private(set) lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A horizontal stack view that contains all subviews.
    private(set) lazy var masterStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [leadingStackView, iconImageView])
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.kf.cancelDownloadTask()
    }
    
    // MARK: Side Effects
    
    /// Configure the appearance and the view hierarchy.
    private func setupLayout() {
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 8
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(masterStackView)
        
        /// At the very first moment, the height of this cell will be a fixed value (44), decreasing the priority of the stack view bottom constraint allows the auto-layout engine to break it.
        let masterStackViewBottomConstraint = masterStackView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        masterStackViewBottomConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 60),
            iconImageView.heightAnchor.constraint(equalToConstant: 60),
            
            masterStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            masterStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            masterStackViewBottomConstraint,
            masterStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8),
        ])
    }
    
    /// Configure the appearance to displays a forecast.
    /// - Parameters:
    ///   - forecast: The expected weather conditions what is judged likely to happen in the future.
    ///   - dateFormatter: A formatter that converts between dates and their textual representations.
    ///   - measurementFormatter: A formatter that provides localized representations of units and measurements.
    ///   - imageURLFactory: An object helps to Initiate an object helps to make an URL of an image.
    func configure(
        withForecast forecast: Forecast,
        dateFormatter: DateFormatter,
        measurementFormatter: MeasurementFormatter,
        imageURLFactory: ImageURLFactory?
    ) {
        dateLabel.text = makeDate(forecast: forecast, dateFormatter: dateFormatter)
        averageTemperatureLabel.text = makeAverageTemperature(forecast: forecast, measurementFormatter: measurementFormatter)
        pressureLabel.text = makePressure(forecast: forecast, measurementFormatter: measurementFormatter)
        humidityLabel.text = makeHumidity(forecast: forecast)
        descriptionLabel.text = makeDescription(forecast: forecast)
        // Hide all empty labels.
        [dateLabel, averageTemperatureLabel, pressureLabel, humidityLabel, descriptionLabel]
            .forEach { $0.isHidden = $0.text?.isEmpty ?? true }
        let icon = imageURLFactory.flatMap { makeIcon(forecast: forecast, imageURLFactory: $0) }
        iconImageView.kf.setImage(with: icon)
        iconImageView.isHidden = icon == nil
    }
    
    // MARK: Utilities
    
    /// Make a text that describes the average temperature of forecast.
    /// - Parameters:
    ///   - forecast: The expected weather conditions what is judged likely to happen in the future.
    ///   - dateFormatter: A formatter that converts between dates and their textual representations.
    /// - Returns: A localized text.
    private func makeDate(forecast: Forecast, dateFormatter: DateFormatter) -> String {
        guard let timeInterval = forecast.date else { return "" }
        let date = dateFormatter.string(from: Date(timeIntervalSince1970: timeInterval))
        let format = NSLocalizedString("Date: %@", comment: "Date: %@")
        let result = String(format: format, date)
        return result
    }
    
    /// Make a text that describes the average temperature of forecast.
    /// - Parameters:
    ///   - forecast: The expected weather conditions what is judged likely to happen in the future.
    ///   - measurementFormatter: A formatter that provides localized representations of units and measurements.
    /// - Returns: An empty text if the temperature data is none, otherwise, a localized text.
    private func makeAverageTemperature(forecast: Forecast, measurementFormatter: MeasurementFormatter) -> String {
        let temperatures = [forecast.temperature?.min, forecast.temperature?.max].compactMap { $0 }
        guard !temperatures.isEmpty else { return "" }
        let averageTemperature = temperatures.reduce(0, +) / Double(temperatures.count)
        let measurement = Measurement<UnitTemperature>(value: averageTemperature, unit: .kelvin)
        let text = measurementFormatter.string(from: measurement)
        let format = NSLocalizedString("Average Temperature: %@", comment: "Average Temperature: %@")
        let result = String(format: format, text)
        return result
    }
    
    /// Make a text that describes the pressure of forecast.
    /// - Parameters:
    ///   - forecast: The expected weather conditions what is judged likely to happen in the future.
    ///   - measurementFormatter: A formatter that provides localized representations of units and measurements.
    /// - Returns: An empty text if the pressure data is none, otherwise, a localized text.
    private func makePressure(forecast: Forecast, measurementFormatter: MeasurementFormatter) -> String {
        guard let pressure = forecast.pressure else { return "" }
        let measurement = Measurement<UnitPressure>(value: pressure, unit: .hectopascals)
        let text = measurementFormatter.string(from: measurement)
        let format = NSLocalizedString("Pressure: %@", comment: "Pressure: %@")
        let result = String(format: format, text)
        return result
    }
    
    /// Make a text that describes the humidity of forecast.
    /// - Parameter forecast: The expected weather conditions what is judged likely to happen in the future.
    /// - Returns: An empty text if the humidity data is none, otherwise, a localized text.
    private func makeHumidity(forecast: Forecast) -> String {
        guard let humidity = forecast.humidity else { return "" }
        let text = "\(Int(humidity))%"
        let format = NSLocalizedString("Humidity: %@", comment: "Humidity: %@")
        let result = String(format: format, text)
        return result
    }
    
    /// Make a text that describes the weather of forecast.
    /// - Parameter forecast: The expected weather conditions what is judged likely to happen in the future.
    /// - Returns: An empty text if the weather data is none, otherwise, a localized text.
    private func makeDescription(forecast: Forecast) -> String {
        guard let description = forecast.weather?.first?.desc else { return "" }
        let format = NSLocalizedString("Description: %@", comment: "Description: %@")
        let result = String(format: format, description)
        return result
    }
    
    /// Make an URL that that identifies the location of an image.
    /// - Parameters:
    ///   - forecase: The expected weather conditions what is judged likely to happen in the future.
    ///   - imageURLFactory: An object helps to Initiate an object helps to make an URL of an image.
    /// - Returns: A value that identifies the location of an image.
    private func makeIcon(forecast: Forecast, imageURLFactory: ImageURLFactory) -> URL? {
        forecast
            .weather?
            .first?
            .icon
            .flatMap { imageURLFactory.make(name: $0, scale: 2) }
    }
}

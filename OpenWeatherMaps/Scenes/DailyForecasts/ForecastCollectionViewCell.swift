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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A label that displays the averate temperature of a day.
    private(set) lazy var averageTemperatureLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A label that displays the pressure.
    private(set) lazy var pressureLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A label that displays the humidity.
    private(set) lazy var humidityLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A label that displays the description.
    private(set) lazy var descriptionLabel: UILabel = {
        let view = UILabel()
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
        contentView.addSubview(masterStackView)
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            masterStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            masterStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            masterStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            masterStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    /// Configure the appearance to displays a forecast.
    /// - Parameters:
    ///   - forecast: The expected weather conditions what is judged likely to happen in the future.
    ///   - dateFormatter: A formatter that converts between dates and their textual representations.
    ///   - imageURLFactory: An object helps to Initiate an object helps to make an URL of an image.
    func configure(
        withForecast forecast: Forecast,
        dateFormatter: DateFormatter,
        imageURLFactory: ImageURLFactory?
    ) {
        dateLabel.text = makeDate(forecast: forecast, dateFormatter: dateFormatter)
        averageTemperatureLabel.text = makeAverageTemperature(forecast: forecast)
        pressureLabel.text = makePressure(forecast: forecast)
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
        let date = dateFormatter.string(from: forecast.date)
        let format = NSLocalizedString("Date: %@", comment: "Date: %@")
        let result = String(format: format, date)
        return result
    }
    
    /// Make a text that describes the average temperature of forecast.
    /// - Parameter forecast: The expected weather conditions what is judged likely to happen in the future.
    /// - Returns: An empty text if the temperature data is none, otherwise, a localized text.
    private func makeAverageTemperature(forecast: Forecast) -> String {
        let temperatures = [forecast.temperature?.min, forecast.temperature?.max].compactMap { $0 }
        guard !temperatures.isEmpty else { return "" }
        let averageTemperature = Int(temperatures.reduce(0, +) / Double(temperatures.count))
        let format = NSLocalizedString("Average Temperature: %d", comment: "Average Temperature: %d")
        let result = String(format: format, averageTemperature)
        return result
    }
    
    /// Make a text that describes the pressure of forecast.
    /// - Parameter forecast: The expected weather conditions what is judged likely to happen in the future.
    /// - Returns: An empty text if the pressure data is none, otherwise, a localized text.
    private func makePressure(forecast: Forecast) -> String {
        guard let pressure = forecast.pressure else { return "" }
        let format = NSLocalizedString("Pressure: %d", comment: "Pressure: %d")
        let result = String(format: format, Int(pressure))
        return result
    }
    
    /// Make a text that describes the humidity of forecast.
    /// - Parameter forecast: The expected weather conditions what is judged likely to happen in the future.
    /// - Returns: An empty text if the humidity data is none, otherwise, a localized text.
    private func makeHumidity(forecast: Forecast) -> String {
        guard let humidity = forecast.humidity else { return "" }
        let format = NSLocalizedString("Humidity: %d", comment: "Humidity: %d")
        let result = String(format: format, Int(humidity))
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
            .flatMap { imageURLFactory.make(name: $0) }
    }
}

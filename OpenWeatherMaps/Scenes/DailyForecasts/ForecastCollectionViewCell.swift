//
//  ForecastCollectionViewCell.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 25/06/2022.
//

import UIKit

/// A collection view cell that displays a forecast.
final class ForecastCollectionViewCell: UICollectionViewCell {
    // MARK: Uis
    
    /// A label that displays the date a forecase was publised.
    private(set) lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A vertical stack view at the leading that contains all informative labels.
    private(set) lazy var leadingStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [dateLabel])
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// A horizontal stack view that contains all subviews.
    private(set) lazy var masterStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [leadingStackView])
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
    
    // MARK: Side Effects
    
    /// Configure the appearance and the view hierarchy.
    private func setupLayout() {
        contentView.addSubview(masterStackView)
        NSLayoutConstraint.activate([
            masterStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            masterStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            masterStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            masterStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    /// Configure the appearance to displays a forecast.
    /// - Parameter forecast: The expected weather conditions what is judged likely to happen in the future.
    func configure(withForecast forecast: Forecast, dateFormatter: DateFormatter) {
        dateLabel.text = dateFormatter.string(from: forecast.date)
    }
}

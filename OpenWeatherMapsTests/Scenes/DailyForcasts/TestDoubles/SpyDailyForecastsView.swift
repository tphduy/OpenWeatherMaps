//
//  SpyDailyForecastsView.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Tran on 25/06/2022.
//

import Foundation
@testable import OpenWeatherMaps

final class SpyDailyForecastsView: DailyForecastsViewable {

    var invokedReloadData = false
    var invokedReloadDataCount = 0

    func reloadData() {
        invokedReloadData = true
        invokedReloadDataCount += 1
    }
}

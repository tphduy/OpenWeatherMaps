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

    var invokedShowLoading = false
    var invokedShowLoadingCount = 0

    func showLoading() {
        invokedShowLoading = true
        invokedShowLoadingCount += 1
    }

    var invokedHideLoading = false
    var invokedHideLoadingCount = 0

    func hideLoading() {
        invokedHideLoading = true
        invokedHideLoadingCount += 1
    }

    var invokedShowError = false
    var invokedShowErrorCount = 0
    var invokedShowErrorParameters: (error: Error, Void)?
    var invokedShowErrorParametersList = [(error: Error, Void)]()

    func showError(_ error: Error) {
        invokedShowError = true
        invokedShowErrorCount += 1
        invokedShowErrorParameters = (error, ())
        invokedShowErrorParametersList.append((error, ()))
    }

    var invokedHideError = false
    var invokedHideErrorCount = 0

    func hideError() {
        invokedHideError = true
        invokedHideErrorCount += 1
    }
}

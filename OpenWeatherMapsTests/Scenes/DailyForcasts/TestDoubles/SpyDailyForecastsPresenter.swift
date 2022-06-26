//
//  SpyDailyForecastsPresenter.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Tran on 25/06/2022.
//

import Foundation
@testable import OpenWeatherMaps

final class SpyDailyForecastsPresenter: DailyForecastsPresentable {

    var invokedViewDidLoad = false
    var invokedViewDidLoadCount = 0

    func viewDidLoad() {
        invokedViewDidLoad = true
        invokedViewDidLoadCount += 1
    }

    var invokedViewDidDisappear = false
    var invokedViewDidDisappearCount = 0

    func viewDidDisappear() {
        invokedViewDidDisappear = true
        invokedViewDidDisappearCount += 1
    }

    var invokedKeywordsDidChange = false
    var invokedKeywordsDidChangeCount = 0
    var invokedKeywordsDidChangeParameters: (keywords: String, Void)?
    var invokedKeywordsDidChangeParametersList = [(keywords: String?, Void)]()

    func keywordsDidChange(_ keywords: String) {
        invokedKeywordsDidChange = true
        invokedKeywordsDidChangeCount += 1
        invokedKeywordsDidChangeParameters = (keywords, ())
        invokedKeywordsDidChangeParametersList.append((keywords, ()))
    }

    var invokedNumberOfSections = false
    var invokedNumberOfSectionsCount = 0
    var stubbedNumberOfSectionsResult: Int! = 0

    func numberOfSections() -> Int {
        invokedNumberOfSections = true
        invokedNumberOfSectionsCount += 1
        return stubbedNumberOfSectionsResult
    }

    var invokedNumberOfItems = false
    var invokedNumberOfItemsCount = 0
    var invokedNumberOfItemsParameters: (section: Int, Void)?
    var invokedNumberOfItemsParametersList = [(section: Int, Void)]()
    var stubbedNumberOfItemsResult: Int! = 0

    func numberOfItems(in section: Int) -> Int {
        invokedNumberOfItems = true
        invokedNumberOfItemsCount += 1
        invokedNumberOfItemsParameters = (section, ())
        invokedNumberOfItemsParametersList.append((section, ()))
        return stubbedNumberOfItemsResult
    }

    var invokedItem = false
    var invokedItemCount = 0
    var invokedItemParameters: (indexPath: IndexPath, Void)?
    var invokedItemParametersList = [(indexPath: IndexPath, Void)]()
    var stubbedItemResult: Forecast!

    func item(at indexPath: IndexPath) -> Forecast {
        invokedItem = true
        invokedItemCount += 1
        invokedItemParameters = (indexPath, ())
        invokedItemParametersList.append((indexPath, ()))
        return stubbedItemResult
    }
}

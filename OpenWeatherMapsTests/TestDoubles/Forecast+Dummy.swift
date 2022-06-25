//
//  Forecast+Dummy.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Tran on 25/06/2022.
//

import Foundation
@testable import OpenWeatherMaps

extension Forecast {
    /// A dummy value.
    static var dummy: Self {
        let data = """
        {"dt":1655956800,"sunrise":1655937160,"sunset":1655983088,"temp":{"day":304.84,"min":298.7,"max":307.03,"night":299.58,"eve":300.77,"morn":298.7},"feels_like":{"day":309.51,"night":299.58,"eve":304.45,"morn":299.61},"pressure":1009,"humidity":60,"weather":[{"id":501,"main":"Rain","description":"moderate rain","icon":"10d"}],"speed":3.6,"deg":168,"gust":6.95,"clouds":100,"pop":0.96,"rain":4.78}
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let result = try! decoder.decode(Self.self, from: data)
        return result
    }
}

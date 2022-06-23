//
//  DailyForecastResponse+Dummy.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Tran on 23/06/2022.
//

import Foundation
@testable import OpenWeatherMaps

extension DailyForecastResponse {
    /// A dummy value.
    static var dummy: Self {
        let data = """
        {"city":{"id":1580578,"name":"Ho Chi Minh City","coord":{"lon":106.6667,"lat":10.8333},"country":"VN","population":0,"timezone":25200},"cod":"200","message":0.0898575,"cnt":7,"list":[{"dt":1655956800,"sunrise":1655937160,"sunset":1655983088,"temp":{"day":304.84,"min":298.7,"max":307.03,"night":299.58,"eve":300.77,"morn":298.7},"feels_like":{"day":309.51,"night":299.58,"eve":304.45,"morn":299.61},"pressure":1009,"humidity":60,"weather":[{"id":501,"main":"Rain","description":"moderate rain","icon":"10d"}],"speed":3.6,"deg":168,"gust":6.95,"clouds":100,"pop":0.96,"rain":4.78},{"dt":1656043200,"sunrise":1656023573,"sunset":1656069499,"temp":{"day":300.79,"min":298.25,"max":301.14,"night":298.73,"eve":301.09,"morn":298.61},"feels_like":{"day":304.11,"night":299.69,"eve":304.8,"morn":299.51},"pressure":1009,"humidity":78,"weather":[{"id":502,"main":"Rain","description":"heavy intensity rain","icon":"10d"}],"speed":2.49,"deg":64,"gust":4.99,"clouds":99,"pop":1,"rain":19.59},{"dt":1656129600,"sunrise":1656109986,"sunset":1656155910,"temp":{"day":301.83,"min":298.2,"max":303.7,"night":299.01,"eve":303.7,"morn":298.2},"feels_like":{"day":305.89,"night":299.95,"eve":308.76,"morn":299.14},"pressure":1008,"humidity":74,"weather":[{"id":501,"main":"Rain","description":"moderate rain","icon":"10d"}],"speed":3.25,"deg":171,"gust":6.49,"clouds":100,"pop":0.85,"rain":11.14},{"dt":1656216000,"sunrise":1656196400,"sunset":1656242320,"temp":{"day":303.44,"min":298.19,"max":305.9,"night":299.94,"eve":304.37,"morn":298.19},"feels_like":{"day":307.67,"night":302.68,"eve":309.55,"morn":299.13},"pressure":1009,"humidity":65,"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"}],"speed":2.94,"deg":153,"gust":5.58,"clouds":99,"pop":0.77,"rain":1.45},{"dt":1656302400,"sunrise":1656282813,"sunset":1656328730,"temp":{"day":302.45,"min":298.69,"max":305.45,"night":300.15,"eve":305.45,"morn":298.69},"feels_like":{"day":306.96,"night":303.18,"eve":309.71,"morn":299.57},"pressure":1010,"humidity":72,"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"}],"speed":2.79,"deg":194,"gust":5.58,"clouds":100,"pop":0.42,"rain":0.28},{"dt":1656388800,"sunrise":1656369227,"sunset":1656415140,"temp":{"day":304.17,"min":298.61,"max":306.74,"night":300.72,"eve":304.35,"morn":298.61},"feels_like":{"day":308.81,"night":304.07,"eve":309.51,"morn":299.54},"pressure":1009,"humidity":63,"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"}],"speed":3.35,"deg":245,"gust":5.52,"clouds":33,"pop":0.56,"rain":0.74},{"dt":1656475200,"sunrise":1656455642,"sunset":1656501548,"temp":{"day":304.37,"min":298.55,"max":307.1,"night":300.38,"eve":304.51,"morn":298.55},"feels_like":{"day":309.55,"night":303.63,"eve":309.89,"morn":299.44},"pressure":1007,"humidity":64,"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"}],"speed":3.42,"deg":269,"gust":6.62,"clouds":93,"pop":0.66,"rain":1.04}]}
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let result = try! decoder.decode(Self.self, from: data)
        return result
    }
}

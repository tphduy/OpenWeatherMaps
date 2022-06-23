//
//  SpyWebRepository.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Tran on 23/06/2022.
//

import Foundation
import Networkable

final class SpyWebRepository: WebRepository {

    var invokedRequestBuilderGetter = false
    var invokedRequestBuilderGetterCount = 0
    var stubbedRequestBuilder: URLRequestBuildable! = {
        let result = SpyURLRequestBuildable()
        result.stubbedMakeResult = URLRequest(url: URL(string: "https://foo.bar")!)
        return result
    }()

    var requestBuilder: URLRequestBuildable {
        invokedRequestBuilderGetter = true
        invokedRequestBuilderGetterCount += 1
        return stubbedRequestBuilder
    }

    var invokedMiddlewaresGetter = false
    var invokedMiddlewaresGetterCount = 0
    var stubbedMiddlewares: [Middleware]! = []

    var middlewares: [Middleware] {
        invokedMiddlewaresGetter = true
        invokedMiddlewaresGetterCount += 1
        return stubbedMiddlewares
    }

    var invokedSessionGetter = false
    var invokedSessionGetterCount = 0
    var stubbedSession: URLSession! = .stubbed

    var session: URLSession {
        invokedSessionGetter = true
        invokedSessionGetterCount += 1
        return stubbedSession
    }
    
    var invokedCall = false
    var invokedCallCount = 0
    var invokedCallParameters: (endpoint: Endpoint, decoder: JSONDecoder, resultType: Any)?
    var invokedCallParametersList = [(endpoint: Endpoint, decoder: JSONDecoder, resultType: Any)]()
    var stubbedCallResult: Any!
    var stubbedCallError: Error?

    func call<T: Decodable>(
        to endpoint: Endpoint,
        decoder: JSONDecoder,
        resultType: T.Type
    ) async throws -> T {
        invokedCall = true
        invokedCallCount += 1
        invokedCallParameters = (endpoint, decoder, resultType)
        invokedCallParametersList.append((endpoint, decoder, resultType))
        if let error = stubbedCallError { throw error }
        return stubbedCallResult as! T
    }
}

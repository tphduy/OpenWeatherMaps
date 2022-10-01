//
//  SpyNetworkableSession.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Trần on 01/10/2022.
//

import Foundation
import Networkable
import Combine

final class SpyNetworkableSession: NetworkableSession {
    
    var invokedDataTaskFor = false
    var invokedDataTaskForCount = 0
    var invokedDataTaskForParameters: (request: Request, resultQueue: DispatchQueue?, decoder: JSONDecoder)?
    var invokedDataTaskForParametersList = [(request: Request, resultQueue: DispatchQueue?, decoder: JSONDecoder)]()
    var stubbedDataTaskForPromiseResult: (Result<Any, Error>, Void)?
    var stubbedDataTaskForResult: URLSessionDataTask!

    func dataTask<T>(
        for request: Request,
        resultQueue: DispatchQueue?,
        decoder: JSONDecoder,
        promise: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionDataTask? where T: Decodable {
        invokedDataTaskFor = true
        invokedDataTaskForCount += 1
        invokedDataTaskForParameters = (request, resultQueue, decoder)
        invokedDataTaskForParametersList.append((request, resultQueue, decoder))
        if let stubbed = stubbedDataTaskForPromiseResult?.0 {
            let result = stubbed.map { $0 as! T }
            promise(result)
        }
        return stubbedDataTaskForResult
    }

    var invokedDataTask = false
    var invokedDataTaskCount = 0
    var invokedDataTaskParameters: (request: Request, resultQueue: DispatchQueue?)?
    var invokedDataTaskParametersList = [(request: Request, resultQueue: DispatchQueue?)]()
    var stubbedDataTaskPromiseResult: (Result<Void, Error>, Void)?
    var stubbedDataTaskResult: URLSessionDataTask!

    func dataTask(
        for request: Request,
        resultQueue: DispatchQueue?,
        promise: @escaping (Result<Void, Error>) -> Void
    ) -> URLSessionDataTask? {
        invokedDataTask = true
        invokedDataTaskCount += 1
        invokedDataTaskParameters = (request, resultQueue)
        invokedDataTaskParametersList.append((request, resultQueue))
        if let result = stubbedDataTaskPromiseResult {
            promise(result.0)
        }
        return stubbedDataTaskResult
    }

    var invokedDataTaskPublisherFor = false
    var invokedDataTaskPublisherForCount = 0
    var invokedDataTaskPublisherForParameters: (request: Request, resultQueue: DispatchQueue?, decoder: JSONDecoder)?
    var invokedDataTaskPublisherForParametersList = [(request: Request, resultQueue: DispatchQueue?, decoder: JSONDecoder)]()
    var stubbedDataTaskPublisherForResult: AnyPublisher<Any, Error>!

    func dataTaskPublisher<T>(
        for request: Request,
        resultQueue: DispatchQueue?,
        decoder: JSONDecoder
    ) -> AnyPublisher<T, Error> where T: Decodable {
        invokedDataTaskPublisherFor = true
        invokedDataTaskPublisherForCount += 1
        invokedDataTaskPublisherForParameters = (request, resultQueue, decoder)
        invokedDataTaskPublisherForParametersList.append((request, resultQueue, decoder))
        return stubbedDataTaskPublisherForResult!
            .map { $0 as! T }
            .eraseToAnyPublisher()
    }

    var invokedDataTaskPublisher = false
    var invokedDataTaskPublisherCount = 0
    var invokedDataTaskPublisherParameters: (request: Request, resultQueue: DispatchQueue?)?
    var invokedDataTaskPublisherParametersList = [(request: Request, resultQueue: DispatchQueue?)]()
    var stubbedDataTaskPublisherResult: AnyPublisher<Void, Error>!

    func dataTaskPublisher(
        for request: Request,
        resultQueue: DispatchQueue?
    ) -> AnyPublisher<Void, Error> {
        invokedDataTaskPublisher = true
        invokedDataTaskPublisherCount += 1
        invokedDataTaskPublisherParameters = (request, resultQueue)
        invokedDataTaskPublisherParametersList.append((request, resultQueue))
        return stubbedDataTaskPublisherResult
    }

    var invokedDataFor = false
    var invokedDataForCount = 0
    var invokedDataForParameters: (request: Request, decoder: JSONDecoder)?
    var invokedDataForParametersList = [(request: Request, decoder: JSONDecoder)]()
    var stubbedDataForError: Error?
    var stubbedDataForResult: Any!

    func data<T>(
        for request: Request,
        decoder: JSONDecoder
    ) async throws -> T where T: Decodable {
        invokedDataFor = true
        invokedDataForCount += 1
        invokedDataForParameters = (request, decoder)
        invokedDataForParametersList.append((request, decoder))
        if let error = stubbedDataForError {
            throw error
        }
        return stubbedDataForResult as! T
    }

    var invokedData = false
    var invokedDataCount = 0
    var invokedDataParameters: (request: Request, Void)?
    var invokedDataParametersList = [(request: Request, Void)]()
    var stubbedDataError: Error?

    func data(for request: Request) async throws {
        invokedData = true
        invokedDataCount += 1
        invokedDataParameters = (request, ())
        invokedDataParametersList.append((request, ()))
        if let error = stubbedDataError {
            throw error
        }
    }
}

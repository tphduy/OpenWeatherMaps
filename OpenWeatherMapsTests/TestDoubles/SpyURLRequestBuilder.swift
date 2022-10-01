//
//  SpyURLRequestBuilder.swift
//  NetworkableTests
//
//  Created by Duy Tran on 7/13/20.
//

import Foundation
import Networkable

final class SpyURLRequestBuilder: URLRequestBuildable {

    var invokedBuild = false
    var invokedBuildCount = 0
    var invokedBuildParameters: (request: Request, Void)?
    var invokedBuildParametersList = [(request: Request, Void)]()
    var stubbedBuildError: Error?
    var stubbedBuildResult: URLRequest!

    func build(request: Request) throws -> URLRequest {
        invokedBuild = true
        invokedBuildCount += 1
        invokedBuildParameters = (request, ())
        invokedBuildParametersList.append((request, ()))
        if let error = stubbedBuildError {
            throw error
        }
        return stubbedBuildResult
    }
}

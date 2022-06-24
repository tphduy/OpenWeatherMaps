//
//  LocalizationMiddlewareTests.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Tran on 24/06/2022.
//

import XCTest
@testable import OpenWeatherMaps

final class LocalizationMiddlewareTests: XCTestCase {
    // MARK: Misc
    
    private var urlComponents: URLComponents!
    private var request: URLRequest!
    private var response: URLResponse!
    private var locale: Locale!
    private var languageQueryItemName: String!
    private var sut: LocalizationMiddleware!
    
    // MARK: Life Cycle

    override func setUpWithError() throws {
        urlComponents = makeURLComponents()
        request = makeRequest()
        response = makeResponse()
        locale = Locale(identifier: "en_US")
        languageQueryItemName = "foo"
        sut = LocalizationMiddleware(locale: locale, languageQueryItemName: languageQueryItemName)
    }

    override func tearDownWithError() throws {
        urlComponents = nil
        request = nil
        response = nil
        locale = nil
        languageQueryItemName = nil
        sut = nil
    }

    // MARK: Test Cases - prepare(request:)
    
    func test_prepareRequest_whenLocaleIsUndefined() throws {
        locale = Locale(identifier: "")
        sut = LocalizationMiddleware(locale: locale, languageQueryItemName: languageQueryItemName)
        
        XCTAssertNil(locale.languageCode)
        XCTAssertNil(locale.regionCode)
        
        let result = try sut.prepare(request: request)
        
        XCTAssertEqual(request, result)
    }
    
    func test_prepareRequest_whenLocaleIsDefined_andLanguageQueryItemNameIsNone() throws {
        sut = LocalizationMiddleware(locale: locale, languageQueryItemName: nil)
        
        XCTAssertNotNil(locale.languageCode)
        XCTAssertNotNil(locale.regionCode)
        
        let result = try sut.prepare(request: request)
        
        XCTAssertNotEqual(request, result)
        XCTAssertTrue(result.allHTTPHeaderFields!.contains(where: { (key, value) in
            key == "Accept-Language" && value == "\(locale.languageCode!)-\(locale.regionCode!)"
        }))
        XCTAssertEqual(request.url?.query, result.url?.query)
    }
    
    func test_prepareRequest_whenLocaleIsDefined_andLanguageQueryItemNameIsSome_andQueryItemsAreCurrentlyNone() throws {
        urlComponents = makeURLComponents(hasQueryItems: false)
        request = makeRequest()
        
        XCTAssertNotNil(locale.languageCode)
        XCTAssertNotNil(locale.regionCode)
        XCTAssertNil(request.url?.query)
        
        let result = try sut.prepare(request: request)
        
        XCTAssertNotEqual(request, result)
        XCTAssertTrue(result.allHTTPHeaderFields!.contains(where: { (key, value) in
            key == "Accept-Language" && value == "\(locale.languageCode!)-\(locale.regionCode!)"
        }))
        XCTAssertTrue(result.url!.query!.contains("\(languageQueryItemName!)=\(locale.languageCode!)"))
    }
    
    func test_prepareRequest_whenLocaleIsDefined_andLanguageQueryItemNameIsSome_andQueryItemsAreCurrentlyAreSome() throws {
        XCTAssertNotNil(locale.languageCode)
        XCTAssertNotNil(locale.regionCode)
        XCTAssertNotNil(request.url?.query)
        XCTAssertFalse(request.url!.query!.isEmpty)
        
        let result = try sut.prepare(request: request)
        
        XCTAssertNotEqual(request, result)
        XCTAssertTrue(result.allHTTPHeaderFields!.contains(where: { (key, value) in
            key == "Accept-Language" && value == "\(locale.languageCode!)-\(locale.regionCode!)"
        }))
        XCTAssertTrue(result.url!.query!.contains("\(languageQueryItemName!)=\(locale.languageCode!)"))
    }
    
    // MARK: Test Cases - willSend(request:)
    
    func test_willSendRequest() throws {
        XCTAssertNoThrow(sut.willSend(request: request))
    }
    
    // MARK: Test Cases - didReceive(response:data)
    
    func test_didReceiveResponse() throws {
        XCTAssertNoThrow(try sut.didReceive(response: response, data: Data()))
    }
}

extension LocalizationMiddlewareTests {
    // MARK: Utilities
    
    private func makeURLComponents(hasQueryItems: Bool = true) -> URLComponents {
        var result = URLComponents(string: "https://apple.com/foo/bar")!
        guard hasQueryItems else { return result }
        result.queryItems = [
            URLQueryItem(name: "foo", value: "bar"),
            URLQueryItem(name: "fizz", value: "buzz"),
        ]
        return result
    }
    
    private func makeRequest() -> URLRequest {
        var result = URLRequest(url: urlComponents.url!)
        result.addValue("Foo", forHTTPHeaderField: "Bar")
        result.addValue("Fizz", forHTTPHeaderField: "Buzz")
        return result
    }
    
    private func makeResponse() -> URLResponse {
        HTTPURLResponse(
            url: urlComponents.url!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)!
    }
}

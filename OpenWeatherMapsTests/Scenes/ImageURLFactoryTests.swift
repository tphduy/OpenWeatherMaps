//
//  ImageURLFactoryTests.swift
//  OpenWeatherMapsTests
//
//  Created by Duy Tran on 25/06/2022.
//

import XCTest
@testable import OpenWeatherMaps

final class ImageURLFactoryTests: XCTestCase {
    // MARK: UIs
    
    private var baseURL: URL!
    private var sut: ImageURLFactory!
    
    // MARK: Life Cycle
    
    override func setUpWithError() throws {
        baseURL = URL(string: "https://foo.bar")
        sut = ImageURLFactory(baseURL: baseURL)
    }

    override func tearDownWithError() throws {
        baseURL = nil
        sut = nil
    }
    
    // MARK: Test Case - init?(baseURL:)

    func test_init_failureWithBaseURL_whenBaseURLIsInvalid() throws {
        XCTAssertNil(ImageURLFactory(baseURL: ""))
    }
    
    // MARK: Test Case - func make(name:scale:format:)
    
    func test_make() throws {
        let result = sut.make(name: "foo", scale: 2, format: "jpg")
        
        XCTAssertEqual(result, URL(string: "https://foo.bar/foo@2x.jpg"))
    }
    
    func test_make_whenScaleIsOne() throws {
        let result = sut.make(name: "foo", scale: 1, format: "jpg")
        
        XCTAssertEqual(result, URL(string: "https://foo.bar/foo.jpg"))
    }
    
    func test_make_whenFormatIsEmpty() throws {
        let result = sut.make(name: "foo", scale: 2, format: "")
        
        XCTAssertEqual(result, URL(string: "https://foo.bar/foo@2x"))
    }
}

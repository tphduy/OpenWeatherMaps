//
//  LocalizationMiddleware.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 23/06/2022.
//

import Foundation
import Networkable

/// A middleware authorizes an outgoing request.
struct LocalizationMiddleware: Middleware {
    // MARK: Dependencies
    
    /// An object provides information about linguistic, cultural, and technological conventions.
    private let locale: Locale
    
    /// The name of the query item will carry the language code value.
    private let languageQueryItemName: String?
    
    // MARK: Init
    
    /// Initiate a middleware authorizes an outgoing request.
    /// - Parameters:
    ///   - locale: An object provides information about linguistic, cultural, and technological conventions. The default value is `.current`.
    ///   - languageQueryItemName: The name of a query item that will carry the localization specifications. Specify `nil` to not append the localization query items to the outgoing request.
    init(
        locale: Locale = .current,
        languageQueryItemName: String? = "lang"
    ) {
        self.locale = locale
        self.languageQueryItemName = languageQueryItemName
    }
    
    // MARK: Middleware

    func prepare(request: URLRequest) throws -> URLRequest {
        localized(request: request)
    }
    
    func willSend(request: URLRequest) {}
    
    func didReceive(response: URLResponse, data: Data) throws {}
    
    func didReceive(error: Error, of request: URLRequest) {}
    
    // MARK: Side Effects
    
    /// Append the localization headers to a request.
    /// - Parameter request: A URL load request that is independent of protocol or URL scheme.
    private func appendLanguageHeaders(to request: inout URLRequest) {
        let acceptedLanguage = [locale.languageCode, locale.regionCode]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: "-")
        guard !acceptedLanguage.isEmpty else { return }
        request.addValue(acceptedLanguage, forHTTPHeaderField: "Accept-Language")
    }
    
    /// Append a localization query item to a rquest.
    /// - Parameter request: A URL load request that is independent of protocol or URL scheme.
    private func appendLanguageQueryItems(to request: inout URLRequest) {
        guard
            let name = languageQueryItemName,
            let code = locale.languageCode,
            !code.isEmpty,
            let url = request.url,
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            return
        }
        let queryItem = URLQueryItem(name: name, value: code)
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + [queryItem]
        guard let localizedURL = urlComponents.url else { return }
        request.url = localizedURL
    }
    
    /// Return an authorized request from the origin request.
    /// - Parameter request: An object abstracts information about the request.
    /// - Returns: A request with embedded authorization components.
    private func localized(request: URLRequest) -> URLRequest {
        var result = request
        appendLanguageHeaders(to: &result)
        appendLanguageQueryItems(to: &result)
        return result
    }
}

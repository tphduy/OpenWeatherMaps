//
//  ImageURLBuilder.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 25/06/2022.
//

import Foundation

/// An object helps to Initiate an object helps to make an URL of an image.
struct ImageURLFactory {
    // MARK: Dependencies
    
    /// The base URL for all images.
    private let baseURL: URL
    
    // MARK: Init
    
    /// Initiate an object helps to make an URL of an image.
    /// - Parameter baseURL: The base URL for all images.
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    /// Initiate an object helps to make an URL of an image.
    /// - Parameter baseURL: The base URL for all images.
    init?(baseURL: String = Natrium.Config.openWeatherMapImage) {
        guard let url = URL(string: baseURL) else { return nil }
        self.init(baseURL: url)
    }
    
    // MARK:
    
    /// Make an URL of an image.
    /// - Parameters:
    ///   - name: The name of the image file.
    ///   - scale: The scale factor of the image. The default value is `1`.
    ///   - format: The file extension.
    /// - Returns: A value that identifies the location of an image.
    func make(
        name: String,
        scale: UInt = 1,
        format: String = "png"
    ) -> URL {
        let suffix = scale > 1 ? "\(scale)x" : nil
        let fullname = [name, suffix]
            .compactMap { $0 }
            .joined(separator: "@")
        let result = baseURL
            .appendingPathComponent(fullname)
            .appendingPathExtension(format)
        return result
    }
}

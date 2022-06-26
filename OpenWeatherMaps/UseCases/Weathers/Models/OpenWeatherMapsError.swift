//
//  OpenWeatherMapsError.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 26/06/2022.
//

import Foundation

/// An object abstracts the error returned from the OpenWeatherMaps API.
struct OpenWeatherMapsError: LocalizedError, Codable, Equatable {
    /// A message that describes why the error did occur.
    let message: String
    
    // MARK: LocalizedError
    
    var errorDescription: String? { message }
}

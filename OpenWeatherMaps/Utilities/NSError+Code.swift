//
//  NSError+Code.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 04/07/2022.
//

import Foundation

extension NSError {
    /// An enum declare the well-known error codes of  an `NSError` object.
    enum Code: Int {
        /// The code will return if a request was cancelled.
        case cancelled = -999
    }
}

//
//  OSLog+Networking.swift
//  OpenWeatherMaps
//
//  Created by Duy Trần on 30/09/2022.
//

import Foundation
import os.log

extension OSLog {
    /// A container of networking related log messages.
    static var networking: OSLog {
        OSLog(
            subsystem: Bundle.main.bundleIdentifier ?? "",
            category: "networking")
    }
}

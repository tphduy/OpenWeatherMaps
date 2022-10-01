//
//  DummyError.swift
//  NetworkableTests
//
//  Created by Duy Tran on 7/12/20.
//

import Foundation

struct DummyError: Error, Equatable, Codable {
    var uuid = UUID()
}

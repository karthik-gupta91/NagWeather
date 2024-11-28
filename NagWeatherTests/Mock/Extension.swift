//
//  Extension.swift
//  NagWeatherTests
//
//  Created by Kartik Gupta on 28/11/24.
//

import Foundation
import XCTest

extension Bundle {
    static func stubbedDataFromJson(filename: String) -> Data {
        return stubbedData(filename: filename, withExtension: "json")
    }

    static func stubbedData(filename: String, withExtension fileExtension: String) -> Data {
        guard  let stubURL = Bundle(for: NagWeatherTests.self).url(forResource: filename, withExtension: fileExtension) else {
            XCTAssert(false, "\(filename).\(fileExtension) file not found")
            fatalError("file not found")
        }
        guard let stubData = try? Data(contentsOf: stubURL) else {
            XCTAssert(false, "\(filename).\(fileExtension) file cannot be read")
            fatalError("file cannot be read")
        }
        return stubData
    }
}


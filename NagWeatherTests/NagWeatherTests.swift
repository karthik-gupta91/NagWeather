//
//  NagWeatherTests.swift
//  NagWeatherTests
//
//  Created by Kartik Gupta on 28/11/24.
//

import XCTest
@testable import NagWeather

final class NagWeatherTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWeatherDataValidity() {
        let jsonData = Bundle.stubbedDataFromJson(filename: "WeatherModel")

        let decoder = JSONDecoder()
        do {
            let weather = try decoder.decode(WeatherModel.self, from: jsonData)

            XCTAssertEqual(weather.forecast?.forecastday?.count, 5)
        } catch {
            XCTAssert(false, "WeatherModel.json decode failed \(error)")
        }
    }
    
    func testLocationsDataValidity() {
        let jsonData = Bundle.stubbedDataFromJson(filename: "Locations")

        let decoder = JSONDecoder()
        do {
            let locations = try decoder.decode([SLocation].self, from: jsonData)

            XCTAssertEqual(locations.count, 5)
        } catch {
            XCTAssert(false, "WeatherModel.json decode failed \(error)")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

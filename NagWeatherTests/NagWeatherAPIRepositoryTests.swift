//
//  NagWeatherAPIRepositoryTests.swift
//  NagWeatherTests
//
//  Created by Kartik Gupta on 29/11/24.
//

@testable import NagWeather
import XCTest
import Combine

final class NagWeatherAPIRepositoryTests: XCTestCase {

    var urlSession: URLSession!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetchWeatherValid() throws {
        let weatherWebRepository = WeatherAPIRepository(urlSession: urlSession)
        let mockData = Bundle.stubbedDataFromJson(filename: "WeatherModel")

        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }

        let expectation = XCTestExpectation(description: "response")

        weatherWebRepository.fetchWeather(location: "")
            .sink(receiveCompletion: { _ in }, receiveValue: { weatherData in
                XCTAssertEqual(weatherData.forecast?.forecastday?.count, 5)

                expectation.fulfill()
            })
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchWeatherInvalidJson() throws {
        let weatherWebRepository = WeatherAPIRepository(urlSession: urlSession)
        let mockData = "{\"data1\"\"\"}".data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }

        let expectation = XCTestExpectation(description: "response")

        weatherWebRepository.fetchWeather(location: "")
            .sink { operationResult in
                switch operationResult {
                    case .failure(let error):
                        XCTAssertEqual(error.errorDescription, WeatherApiError.decodingError.errorDescription)
                        expectation.fulfill()
                        break
                    case .finished:
                        break
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

}

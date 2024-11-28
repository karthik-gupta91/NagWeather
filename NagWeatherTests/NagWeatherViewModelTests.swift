//
//  NagWeatherViewModelTests.swift
//  NagWeatherTests
//
//  Created by Kartik Gupta on 28/11/24.
//

@testable import NagWeather
import XCTest
import Combine

final class NagWeatherViewModelTests: XCTestCase {

    private var viewModel: WeatherViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = WeatherViewModel(weatherService: WeatherServiceMock())
        viewModel.searchText = "Test"
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
    
    func testWeatherViewModelData() {

        let expectation = XCTestExpectation(description: "fetch weather data")
                
        viewModel.$weatherData.sink(receiveValue: { weatherData in
            if weatherData != nil {
                expectation.fulfill()
            }
        })
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
        
        print(viewModel.weatherData?.location?.name! ?? "")
        XCTAssertEqual(viewModel.weatherData?.location?.name! ?? "", "London")
        XCTAssertEqual(viewModel.tempCFormatted, "4.2ºC")
        XCTAssertEqual(viewModel.feelsLikeCFormatted, "3.8ºC")
        XCTAssertNotNil(viewModel.dayFrom(viewModel.weatherData?.current?.lastUpdated! ?? "2024-11-29"))
    }
    
    func testWeatherViewModelDataFailure() {
        let weatherService = WeatherServiceMock()
        weatherService.shouldReturnError = true
        viewModel = WeatherViewModel(weatherService: weatherService)
        viewModel.searchText = "Test"
        
        let expectation = XCTestExpectation(description: "fetch failue")
                
        viewModel.$errorMessage.sink(receiveValue: { errorMessage in
            if errorMessage.count > 0 {
                expectation.fulfill()
            }
        })
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
        
        print(viewModel.weatherData?.location?.name! ?? "")
        XCTAssertNil(viewModel.weatherData)
    }

}

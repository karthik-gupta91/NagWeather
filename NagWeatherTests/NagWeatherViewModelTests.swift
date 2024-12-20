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

    private var weatherRepo = WeatherRepositoryMock()
    private var viewModel: WeatherViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = WeatherViewModel(weatherRepo: weatherRepo)
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
    func testSearchSuggestionsData() {
        
        weatherRepo.shouldReturnError = false
        
        let expectation = XCTestExpectation(description: "search suggestion list count")
        
        viewModel.searchText = "Lon"
        
        viewModel.$suggestions.sink(receiveValue: { locations in
            if locations.count > 0 {
                expectation.fulfill()
            }
        })
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(viewModel.suggestions.count, 5)
    }
    
    func testSearchSuggestionsFailure() {
        weatherRepo.shouldReturnError = true
        viewModel.searchText = "Test"
        
        let expectation = XCTestExpectation(description: "search list failue")
                
        viewModel.$errorMessage.sink(receiveValue: { errorMessage in
            if errorMessage.count > 0 {
                expectation.fulfill()
            }
        })
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertNil(viewModel.weatherData)
    }
    
    
    func testWeatherViewModelData() {
        weatherRepo.shouldReturnError = false
        let expectation = XCTestExpectation(description: "fetch weather data")
        
        viewModel.performSearch("London")
        
        viewModel.$weatherData.sink(receiveValue: { weatherData in
            if weatherData != nil {
                expectation.fulfill()
            }
        })
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(viewModel.locationName(), "London")
        XCTAssertEqual(viewModel.tempCFormatted, "4.2°C")
        XCTAssertEqual(viewModel.feelsLikeCFormatted, "3.8°C")
        XCTAssertNotNil(viewModel.dayFrom(viewModel.lastUpdated()))
    }
    
    func testWeatherViewModelDataFailure() {
        weatherRepo.shouldReturnError = true
        
        viewModel.performSearch("London")
        
        let expectation = XCTestExpectation(description: "fetch failue")
                
        viewModel.$errorMessage.sink(receiveValue: { errorMessage in
            if errorMessage.count > 0 {
                expectation.fulfill()
            }
        })
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertNil(viewModel.weatherData)
    }

}

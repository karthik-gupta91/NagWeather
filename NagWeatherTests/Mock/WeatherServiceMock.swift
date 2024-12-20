//
//  WeatherServiceMock.swift
//  NagWeatherTests
//
//  Created by Kartik Gupta on 28/11/24.
//

import Foundation
import Combine
@testable import NagWeather

class WeatherServiceMock: WeatherService {
    
    var shouldReturnError = false
    
    func searchSuggestions(for query: String) -> AnyPublisher<[SLocation], WeatherApiError> {
        if shouldReturnError {
            return Fail(error: WeatherApiError.decodingError)
                .eraseToAnyPublisher()
        } else {
            return Just(createLocationResponseMock())
                .receive(on: DispatchQueue.main)
                .setFailureType(to: WeatherApiError.self)
                .eraseToAnyPublisher()
        }
    }
    
    func saveWeatherData(_ weatherData: WeatherModel) -> AnyPublisher<Void, Error> {
        if shouldReturnError {
            return Fail(error: WeatherApiError.decodingError)
                .eraseToAnyPublisher()
        } else {
            return Just(())
                .receive(on: DispatchQueue.main)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
    }
    
    func fetchWeather(for location: String) -> AnyPublisher<WeatherModel, WeatherApiError> {
        if shouldReturnError {
            return Fail(error: WeatherApiError.decodingError)
                .eraseToAnyPublisher()
        } else {
            return Just(createResponseMock())
                .receive(on: DispatchQueue.main)
                .setFailureType(to: WeatherApiError.self)
                .eraseToAnyPublisher()
        }
    }
    
    func createResponseMock() -> WeatherModel {
        let data = Bundle.stubbedDataFromJson(filename: "WeatherModel")
        let response = try! JSONDecoder().decode(WeatherModel.self, from: data)
        return response
    }
    
    func createLocationResponseMock() -> [SLocation] {
        let data = Bundle.stubbedDataFromJson(filename: "Locations")
        let response = try! JSONDecoder().decode([SLocation].self, from: data)
        return response
    }
}

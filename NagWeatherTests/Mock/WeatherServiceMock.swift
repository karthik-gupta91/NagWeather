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
    
}

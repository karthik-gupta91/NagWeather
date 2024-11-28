//
//  WeatherService.swift
//  NagWeather
//
//  Created by Kartik Gupta on 28/11/24.
//

import Foundation
import Combine

protocol WeatherService {
    func fetchWeather(for location: String) -> AnyPublisher<WeatherModel, WeatherApiError>
}

struct WeatherServiceImpl: WeatherService {
    
    private var weatherAPIRepository: WeatherAPIRepository
    
    init(weatherAPIRepository: WeatherAPIRepository) {
        self.weatherAPIRepository = weatherAPIRepository
    }
    
    func fetchWeather(for location: String) -> AnyPublisher<WeatherModel, WeatherApiError> {
        return weatherAPIRepository.fetchWeather(location: location)
    }
    
}

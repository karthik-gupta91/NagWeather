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
    func searchSuggestions(for query: String) -> AnyPublisher<[SLocation], WeatherApiError>
    func saveWeatherData(_ weatherData: WeatherModel) -> AnyPublisher<Void, Error>
}

struct WeatherServiceImpl: WeatherService {

    private var weatherAPIRepository: WeatherAPIRepository
    private var weatherOfflineRepository: WeatherOfflineRepository
    
    init(weatherAPIRepository: WeatherAPIRepository, weatherOfflineRepository: WeatherOfflineRepository) {
        self.weatherAPIRepository = weatherAPIRepository
        self.weatherOfflineRepository = weatherOfflineRepository
    }
    
    func fetchWeather(for location: String) -> AnyPublisher<WeatherModel, WeatherApiError> {
        if let modifiedDate = weatherOfflineRepository.modifiedDate(location) {
            if let diff = Calendar.current.dateComponents([.hour], from: modifiedDate, to: Date()).hour, diff <= 1 {
                return weatherOfflineRepository.fetchWeatherData(for: location)
            }
        }
        return weatherAPIRepository.fetchWeather(location: location)
    }
    
    func searchSuggestions(for query: String) -> AnyPublisher<[SLocation], WeatherApiError> {
        return weatherAPIRepository.searchSuggestion(query: query)
    }
    
    func saveWeatherData(_ weatherData: WeatherModel) -> AnyPublisher<Void, Error> {
        return weatherOfflineRepository.saveWeatherData(weatherData)
    }
    
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

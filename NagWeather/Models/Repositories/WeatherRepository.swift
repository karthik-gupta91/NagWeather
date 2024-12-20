//
//  WeatherService.swift
//  NagWeather
//
//  Created by Kartik Gupta on 28/11/24.
//

import Foundation
import Combine

protocol WeatherRepository {
    func fetchWeather(for location: String) -> AnyPublisher<WeatherModel, WeatherApiError>
    func searchSuggestions(for query: String) -> AnyPublisher<[SLocation], WeatherApiError>
    func saveWeatherData(_ weatherData: WeatherModel) -> AnyPublisher<Void, Error>
}

struct WeatherRepositoryImpl: WeatherRepository {

    private var weatherAPIService: WeatherAPIService
    private var weatherOfflineService: WeatherOfflineService
    
    init(weatherAPIService: WeatherAPIService, weatherOfflineService: WeatherOfflineService) {
        self.weatherAPIService = weatherAPIService
        self.weatherOfflineService = weatherOfflineService
    }
    
    func fetchWeather(for location: String) -> AnyPublisher<WeatherModel, WeatherApiError> {
        if let modifiedDate = weatherOfflineService.modifiedDate(location) {
            if let diff = Calendar.current.dateComponents([.hour], from: modifiedDate, to: Date()).hour, diff <= 1 {
                return weatherOfflineService.fetchWeatherData(for: location)
            }
        }
        return weatherAPIService.fetchWeather(location: location)
    }
    
    func searchSuggestions(for query: String) -> AnyPublisher<[SLocation], WeatherApiError> {
        return weatherAPIService.searchSuggestion(query: query)
    }
    
    func saveWeatherData(_ weatherData: WeatherModel) -> AnyPublisher<Void, Error> {
        return weatherOfflineService.saveWeatherData(weatherData)
    }
    
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

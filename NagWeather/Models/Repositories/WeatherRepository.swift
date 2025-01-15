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
    func saveWeatherData(_ weatherData: WeatherModel) -> AnyPublisher<Void, WeatherApiError>
}

struct WeatherRepositoryImpl: WeatherRepository {

    private var weatherAPIService: WeatherAPIService
    private var weatherOfflineService: WeatherOfflineService
        
    init(weatherAPIService: WeatherAPIService, weatherOfflineService: WeatherOfflineService) {
        self.weatherAPIService = weatherAPIService
        self.weatherOfflineService = weatherOfflineService
    }
    
    func fetchWeather(for location: String) -> AnyPublisher<WeatherModel, WeatherApiError> {
        weatherOfflineService
            .modifiedDate(for: location)
            .flatMap { date -> AnyPublisher<WeatherModel, WeatherApiError> in
                // Check if the date is within 1 hour
                if let date = date,
                   let diff = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour,
                   diff <= 1 {
                    // Fetch data from offline service
                    return weatherOfflineService.fetchWeatherData(for: location)
                } else {
                    // Fetch data from API
                    return weatherAPIService.fetchWeather(location: location)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func searchSuggestions(for query: String) -> AnyPublisher<[SLocation], WeatherApiError> {
        return weatherAPIService.searchSuggestion(query: query)
    }
    
    func saveWeatherData(_ weatherData: WeatherModel) -> AnyPublisher<Void, WeatherApiError> {
        return weatherOfflineService.saveWeatherData(weatherData)
    }
    
}

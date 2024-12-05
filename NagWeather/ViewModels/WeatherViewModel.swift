//
//  WeatherViewModel.swift
//  NagWeather
//
//  Created by Kartik Gupta on 28/11/24.
//

import Foundation
import Combine

enum WeatherViewState {
    case none
    case loadingLocations
    case locationsLoaded
    case fetchingWeatherData
    case dataLoaded
}

class WeatherViewModel: ObservableObject {
    
    private let weatherService: WeatherService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var searchText: String = ""
    @Published private(set) var weatherData: WeatherModel?
    @Published private(set) var suggestions: [SLocation] = []
    @Published var showAlert = false
    
    @Published private(set) var errorMessage = ""
    
    @Published private(set) var state: WeatherViewState = .none
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
        
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue(label: "SearchSuggestions", qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] query in
                self?.showSuggestions(query: query)
            }
            .store(in: &cancellables)
        
    }
    
    
    func performSearch(_ searchText: String) {
        guard !searchText.isEmpty else {
            return
        }
        state = .fetchingWeatherData
        
        weatherService.fetchWeather(for: searchText)
            .sink { [weak self] operationResult in
                guard let self = self else { return }
                
                switch operationResult {
                case .finished:
                    state = .dataLoaded
                case .failure(let error):
                    state = .none
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                }
            } receiveValue: { weatherData in
                self.weatherData = weatherData
                self.saveWeatherData(weatherData)
            }
            .store(in: &cancellables)
    }
    
    func showSuggestions(query: String) {
        guard query.count > 1 else {
            return
        }
        suggestions = []
        state = .loadingLocations
        
        weatherService.searchSuggestions(for: searchText)
            .sink { [weak self] operationResult in
                guard let self = self else { return }
                
                switch operationResult {
                case .finished:
                    state = .locationsLoaded
                case .failure(let error):
                    state = .none
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                }
            } receiveValue: { slocations in
                if slocations.count > 0 {
                    self.suggestions = slocations
                } else {
                    self.state = .none
                    self.errorMessage = "No suggestions found"
                    self.showAlert = true
                }
            }
            .store(in: &cancellables)
    }
    
    func saveWeatherData(_ weatherData: WeatherModel) {
        weatherService.saveWeatherData(weatherData)
            .sink {}
            .store(in: &cancellables)
    }
    
    var tempCFormatted: String {
        return "\(weatherData?.current?.tempC ?? 0.0)" + AppConstants.degreeCelcius
    }

    var feelsLikeCFormatted: String {
        return "\(weatherData?.current?.feelslikeC ?? 0.0)" + AppConstants.degreeCelcius
    }
    
    func dayFrom(_ str: String) -> String {
        return Helpers.dayOfWeek(from: str) ?? ""
    }
    
    func checkIFWeatherData() -> Bool {
        if weatherData != nil {
            return true
        }
        return false
    }
    
    func locationName() -> String {
        return weatherData?.location?.name ?? ""
    }
    
    func currentWeatherCondition() -> String {
        return weatherData?.current?.condition?.text ?? ""
    }
    
    func lastUpdated() -> String {
        return weatherData?.current?.lastUpdated ?? ""
    }
    
    func countryName() -> String {
        return weatherData?.location?.country ?? ""
    }
    
    func currentHumidity() -> String {
        return "\(weatherData?.current?.humidity ?? 0)"
    }
    
    func windKPH() -> String {
        return "\(weatherData?.current?.windKph ?? 0)"
    }
    
    func forecastDays() -> [Forecastday] {
        return weatherData?.forecast?.forecastday ?? []
    }
}


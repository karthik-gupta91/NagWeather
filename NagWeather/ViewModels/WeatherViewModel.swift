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
    case failed(String)
}

class WeatherViewModel: ObservableObject {
    
    private let weatherRepo: WeatherRepository
    private var cancellables = Set<AnyCancellable>()
    
    @Published var searchText: String = ""
    @Published private(set) var weatherData: WeatherModel?
    @Published private(set) var suggestions: [SLocation] = []
    @Published var showAlert = false
    
    @Published private(set) var errorMessage = ""
    
    @Published private(set) var state: WeatherViewState = .none
    
    private let searchQueueLabel = "SearchSuggestions"

    init(weatherRepo: WeatherRepository) {
        self.weatherRepo = weatherRepo
        
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue(label: searchQueueLabel, qos: .userInteractive))
            .receive(on: RunLoop.main)
            .sink { [weak self] query in
                self?.showSuggestions(query: query)
            }
            .store(in: &cancellables)
        
    }
    
    
    func performSearch(_ searchText: String) {
        guard !searchText.isEmpty else { return }
        
        state = .fetchingWeatherData
        weatherRepo.fetchWeather(for: searchText)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.state = .dataLoaded
                case .failure(let error):
                    self?.state = .failed(error.localizedDescription)
                    self?.showAlert = true
                }
            }, receiveValue: { [weak self] weatherData in
                self?.weatherData = weatherData
                self?.saveWeatherData(weatherData)
            })
            .store(in: &cancellables)
    }
    
    func showSuggestions(query: String) {
        guard query.count > 1 else {
            return
        }
        suggestions = []
        state = .loadingLocations
        
        weatherRepo.searchSuggestions(for: searchText)
            .sink { [weak self] operationResult in
                guard let self = self else { return }
                
                switch operationResult {
                case .finished:
                    state = .locationsLoaded
                case .failure(let error):
                    state = .failed(error.localizedDescription)
                    self.showAlert = true
                }
            } receiveValue: { slocations in
                if slocations.count > 0 {
                    self.suggestions = slocations
                } else {
                    self.state = .none
                    self.errorMessage = AppConstants.AlertConstants.noSuggestionFound
                    self.showAlert = true
                }
            }
            .store(in: &cancellables)
    }
    
    func saveWeatherData(_ weatherData: WeatherModel) {
        weatherRepo.saveWeatherData(weatherData)
            .sink { [weak self] operationResult in
                guard self != nil else { return }
                switch operationResult {
                case .finished:
                    print("weather data saved successfully")
                case .failure(let error):
                    print("weather data saving failed \(error)")
                }
            } receiveValue: {}
            .store(in: &cancellables)
    }
    
    var tempCFormatted: String {
        return "\(weatherData?.current?.tempC ?? 0.0)" + AppConstants.degreeCelcius
    }

    var feelsLikeCFormatted: String {
        return "\(weatherData?.current?.feelslikeC ?? 0.0)" + AppConstants.degreeCelcius
    }
    
    func dayFrom(_ str: String) -> String {
        if let day = Helpers.dayOfWeek(from: str) {
            return day
        } else {
            return Helpers.day(from: str) ?? ""
        }
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


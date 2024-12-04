//
//  WeatherViewModel.swift
//  NagWeather
//
//  Created by Kartik Gupta on 28/11/24.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    
    private let weatherService: WeatherService
    private var cancellables = Set<AnyCancellable>()
    
    var searchText: String = ""
    @Published private(set) var weatherData: WeatherModel?
    @Published var isLoading: Bool = false
    @Published var showAlert = false
    
    @Published private(set) var errorMessage = ""
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
        
//        $searchText
//            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
//            .removeDuplicates()
//            .sink { [weak self] query in
//                self?.performSearch(query: query)
//            }
//            .store(in: &cancellables)
        
    }
    
    
    func performSearch() {
        guard !searchText.isEmpty else {
            return
        }
        isLoading = true
        
        weatherService.fetchWeather(for: searchText)
            .sink { [weak self] operationResult in
                guard let self = self else { return }
                
                switch operationResult {
                case .finished:
                    isLoading = false
                case .failure(let error):
                    isLoading = false
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                }
            } receiveValue: { weatherData in
                self.weatherData = weatherData
                print(weatherData)
            }
            .store(in: &cancellables)
    }
    
    var tempCFormatted: String {
        return "\(weatherData?.current?.tempC ?? 0.0)" + "°C"
    }

    var feelsLikeCFormatted: String {
        return "\(weatherData?.current?.feelslikeC ?? 0.0)" + "°C"
    }
    
    func dayFrom(_ str: String) -> String {
        let date = Helpers.stringToDate(str: str)
        if Calendar.current.isDateInToday(date) {
            return "Today"
        }
        return Helpers.dayOfWeek(from: str) ?? ""
    }
    
}


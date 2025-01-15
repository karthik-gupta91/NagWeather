//
//  ContentView.swift
//  NagWeather
//
//  Created by Kartik Gupta on 28/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                viewContent
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(
                            title: Text(AppConstants.AlertConstants.alert),
                            message: Text(viewModel.errorMessage),
                            dismissButton: .default(Text(AppConstants.AlertConstants.ok))
                        )
                    }
                    .padding()
            }
            .searchable(text: $viewModel.searchText)
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                AppConstants.WeatherColor.AppBackground,
                AppConstants.WeatherColor.AccentColor
            ]),
            startPoint: .top,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    
    @ViewBuilder
    private var viewContent: some View {
        switch viewModel.state {
        case .loadingLocations, .fetchingWeatherData:
            ProgressViewWithText(text: AppConstants.AlertConstants.loading)
            
        case .locationsLoaded:
            suggestionsList
            
        case .dataLoaded:
            currentWeatherView
            
        default:
            EmptyView()
        }
    }
    
    private var suggestionsList: some View {
        List(viewModel.suggestions) { location in
            Button("\(location.name), \(location.region ?? ""), \(location.country ?? "")") {
                viewModel.performSearch(location.name)
            }
            .buttonStyle(PlainButtonStyle())
            .listRowBackground(Color.clear)
            .accessibilityLabel("Suggestion for \(location.name)")
        }
        .listStyle(.plain)
        .accessibilityIdentifier("searchSuggestionList")
    }
    
    private var currentWeatherView: some View {
        VStack(spacing: 4) {
            locationDetails
            weatherDetails
            weatherForecast
        }
    }
    
    private var locationDetails: some View {
        VStack(spacing: 4) {
            Text(viewModel.locationName())
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(.black)
            
            Text(viewModel.countryName())
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.red)
        }
    }
    
    private var weatherDetails: some View {
        VStack(spacing: 4) {
            Text(viewModel.tempCFormatted)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            Text("\(viewModel.currentWeatherCondition()) - \(viewModel.feelsLikeCFormatted)")
                .foregroundColor(.black)
            
            Text(AppConstants.lastUpdatedAt + " - " + viewModel.lastUpdated())
                .foregroundColor(.black)
            
            Divider().background(.black)
            
            HStack {
                Text(AppConstants.humidity)
                Spacer()
                Text(viewModel.currentHumidity())
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.black)
            
            HStack {
                Text(AppConstants.windDirection)
                Spacer()
                Text(viewModel.windKPH())
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.black)
        }
    }
    
    private var weatherForecast: some View {
        VStack(spacing: 4) {
            Text(AppConstants.weatherForecast)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            ForEach(viewModel.forecastDays()) { day in
                DaySummaryView(
                    day: viewModel.dayFrom(day.date ?? "2000-11-11"),
                    highTemp: "\(day.day?.maxtempC ?? 0) \(AppConstants.degreeCelcius)",
                    lowTemp: "\(day.day?.mintempC ?? 0) \(AppConstants.degreeCelcius)"
                )
            }
        }
    }
    
}

#Preview {
    ContentView(viewModel: WeatherViewModel(weatherRepo: WeatherRepositoryImpl(weatherAPIService: WeatherAPIService(urlSession: URLSession(configuration: .default)), weatherOfflineService: WeatherOfflineService())))
}

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
        
        NavigationStack{
            ZStack {
                LinearGradient(gradient:
                                Gradient(colors: [
                                    AppConstants.WeatherColor.AppBackground,
                                    AppConstants.WeatherColor.AppBackground,
                                    AppConstants.WeatherColor.AccentColor,
                                ]), startPoint: .top, endPoint: .bottomTrailing).ignoresSafeArea()

                VisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark)).ignoresSafeArea()
                
                VStack {
                    if viewModel.state == .loadingLocations {
                        HStack(spacing: 15) {
                            ProgressView()
                            Text(AppConstants.AlertConstants.loading)
                        }
                    } else if viewModel.state == .locationsLoaded {
                        List(viewModel.suggestions) { location in
                            HStack {
                                Button("\(location.name), \(location.region ?? ""), \(location.country ?? "")") {
                                    viewModel.performSearch(location.name)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }.listRowBackground(Color.clear) 
                        }
                        .listStyle(.plain)
                        .accessibilityIdentifier("searchSuggestionList")
                    } else if viewModel.state == .fetchingWeatherData {
                        HStack(spacing: 15) {
                            ProgressView()
                            Text(AppConstants.AlertConstants.loading)
                        }
                    } else if viewModel.state == .dataLoaded {
                        currentWeatherView
                    }
                }.alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text(AppConstants.AlertConstants.alert), message:
                            Text(viewModel.errorMessage),
                          dismissButton: .default(Text(AppConstants.AlertConstants.ok)))
                }.padding()
                
            }
        }.searchable(text: $viewModel.searchText)
        
    }
    
    private var currentWeatherView: some View {
        return VStack(spacing: 4) {
            
            Text(viewModel.locationName())
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(.black)
            
            Text(viewModel.tempCFormatted)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            Text(viewModel.currentWeatherCondition() + "-" + viewModel.feelsLikeCFormatted)
                .foregroundColor(.black)
            Text(AppConstants.lastUpdatedAt + "-" + viewModel.dayFrom(viewModel.lastUpdated()))
                .foregroundColor(.black)
            
            Spacer()
            
            Text(viewModel.locationName())
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.red)
            
            Text(viewModel.countryName())
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            Divider().background(.black)
            
            HStack {
                Text(AppConstants.humidity)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Spacer()
                Text(viewModel.currentHumidity()).font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            
            HStack {
                Text(AppConstants.windDirection)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Spacer()
                Text(viewModel.windKPH() ).font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text(AppConstants.weatherForecast).font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            ForEach(viewModel.forecastDays()) { day in
                DaySummaryView(day: viewModel.dayFrom(day.date ?? "2000-11-11"), highTemp: "\(day.day?.maxtempC ?? 0) \(AppConstants.degreeCelcius)", lowTemp: "\(day.day?.mintempC ?? 0) \(AppConstants.degreeCelcius)")
            }
            
        }
    }
    
}

#Preview {
    ContentView(viewModel: WeatherViewModel(weatherService: WeatherServiceImpl(weatherAPIRepository: WeatherAPIRepository(urlSession: URLSession(configuration: .default)), weatherOfflineRepository: WeatherOfflineRepository())))
}

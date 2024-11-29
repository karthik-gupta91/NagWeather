//
//  ContentView.swift
//  NagWeather
//
//  Created by Kartik Gupta on 28/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = WeatherViewModel(weatherService: WeatherServiceImpl(weatherAPIRepository: WeatherAPIRepository(urlSession: URLSession(configuration: .default))))
    
    var body: some View {
        
        NavigationStack{
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    if viewModel.isLoading {
                        HStack(spacing: 15) {
                            ProgressView()
                            Text("Loading…")
                        }
                    } else if viewModel.weatherData != nil {
                        currentWeatherView
                    }
                }.alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Login Error"), message:
                            Text(viewModel.errorMessage),
                          dismissButton: .default(Text("Ok")))
                }  
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background { BackgroundView() }
        }.searchable(text: $viewModel.searchText, prompt: "")
        
    }
    
    private var currentWeatherView: some View {
        return VStack(spacing: 4) {
            
            Text(viewModel.weatherData?.location?.name ?? "")
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(.black)
            
            Text(viewModel.tempCFormatted)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            Text("\(viewModel.weatherData?.current?.condition?.text ?? "") - \(viewModel.feelsLikeCFormatted)")
                .foregroundColor(.black)
            Text("Last updated at - \(viewModel.dayFrom(viewModel.weatherData?.current?.lastUpdated ?? ""))")
                .foregroundColor(.black)
            
            Spacer()
            
            Text(viewModel.weatherData?.location?.name ?? "")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.red)
            
            Text(viewModel.weatherData?.location?.country ?? "")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            Divider().background(.black)
            
            HStack {
                Text("Humidity")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Spacer()
                Text("\(viewModel.weatherData?.current?.humidity ?? 0)").font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            
            HStack {
                Text("Wind Direction")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Spacer()
                Text("\(viewModel.weatherData?.current?.windKph ?? 0)").font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("Weather Forecast").font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            ForEach(viewModel.weatherData?.forecast?.forecastday ?? []) { day in
                DaySummaryView(day: viewModel.dayFrom(day.date ?? "2000-11-11"), highTemp: "\(day.day?.maxtempC ?? 0) ºC", lowTemp: "\(day.day?.mintempC ?? 0) ºC")
            }
            
        }
    }
    
}

#Preview {
    ContentView()
}

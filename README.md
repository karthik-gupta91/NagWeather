# NagWeather - SwiftUI(iOS)


## Overview

`NagWeather` application provides weather information for a city selected by the user. Using the MVVM architectural pattern, it ensures separation of concerns, clean code, and scalability. The app implements a caching mechanism to optimize API usage and enhance performance.

## Features
 ### City Search Suggestions
  - Provides suggestions as the user types the city name.
 ### Weather Information Display
  - Fetches and displays real-time weather data for the selected city.
 ### Caching
  - Saves weather data locally to reduce redundant API calls.
 ### Optimized Performance
  - Avoids unnecessary API calls for frequently selected cities.

## TechStack
  - SwiftUI
  - Combine
  - JSON & Codable
  - FileManager
  - MVVM
 

## Technical Architecture

  - This app follows the MVVM pattern for better separation of concerns
   
### Model
  - Responsible for data fetching and storage.
  - Handles API calls and caching logic.
  - Components:
    1. Data Models
    2. WeatherService
    3. WeatherRepository

### ViewModel
 - Acts as a bridge between Model and View.
 - Processes data from the repositories and provides it to the View.
 - Handles business logic such as:
 - Triggering API calls based on user actions.
 - Updating the View with the appropriate data.
 - Components:
    1. WeatherViewModel

### Views
 - Observes the ViewModel for updates.
 - Displays suggestions and weather data to the user.
 - Sends user interactions (e.g., type text) to the ViewModel.
 - Components:
    1. ContentView
    2. DaySummaryView

## Flow Breakdown:

 ### User Search:

  1. The user starts typing the name of a city.
  2. A search API is called to provide suggestions based on the input.

 ### Suggestion Selection:

  1. When the user clicks on a suggestion, the selected location's weather data is fetched via the Weather API.

 ### Data Storage:

  1. The fetched weather data is saved in a local directory.

 ### Subsequent Requests:

  1. If the user selects the same city again:
     - Check the cache for existing weather data.
     - Validate if the data has expired based on a predefined expiration time.
  2. If valid data exists: Retrieve and display it from the cache.
  3. If expired or missing: Fetch fresh data from the Weather API, update the cache, and display it.


## Getting Started

 ### Prerequisites

  - A valid API key from weatherapi.com
  - A Mac running macOS Sonoma 14.5
  - Xcode 15.4

 ### Installation

  1. Clone or download the project to your local machine
  2. Open the project in Xcode
  3. Replace `YOURAPIKEY` with your valid weatherapi.com API key in `AppConstants.swift`
  4. Run the simulator

 ### Working
  1. Open the application
  2. Search for any location in the world
  3. Select city from the suggestion list
  4. Weather will be displayed

### Screenshot

<img width="386" alt="Screenshot 2024-12-05 at 4 05 41 PM" src="https://github.com/user-attachments/assets/5b7c52f7-58a6-4b0f-b6af-59ffe9a734a0">
<img width="379" alt="Screenshot 2024-12-05 at 4 05 54 PM" src="https://github.com/user-attachments/assets/cb4341e4-ee58-4791-873a-9dabc77f10f0">
<img width="377" alt="Screenshot 2024-12-05 at 4 06 04 PM" src="https://github.com/user-attachments/assets/2e77fa6a-148a-411b-8294-054e2727f102">
<img width="372" alt="Screenshot 2024-12-05 at 4 06 15 PM" src="https://github.com/user-attachments/assets/209c45d0-3da8-427b-a818-713a3ea2b88e">

### TestCoverageReport

<img width="1505" alt="Screenshot 2024-12-20 at 3 00 13 PM" src="https://github.com/user-attachments/assets/28ce9f59-c51f-4e8c-8b37-98e73f836c81" />




## Thanks to

Apple amazing library [SwiftUI](https://developer.apple.com/xcode/swiftui/)

Open API from [[WeatherAPI](https://api.weatherapi.co)]

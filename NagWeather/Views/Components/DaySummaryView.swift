//
//  DaySummaryView.swift
//  NagWeather
//
//  Created by Kartik Gupta on 28/11/24.
//

import SwiftUI

struct DaySummaryView: View {
    let day: String
    let highTemp: String
    let lowTemp: String

    var body: some View {
        HStack {
            Text(day)
                .fontWeight(.medium)
            Spacer()
            Text("\(highTemp) / \(lowTemp)")
                .fontWeight(.light)
        }
        .padding(.horizontal)
        .padding(.vertical, 22)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct DaySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        return DaySummaryView(day: "Monday", highTemp: "19", lowTemp: "16")
    }
}

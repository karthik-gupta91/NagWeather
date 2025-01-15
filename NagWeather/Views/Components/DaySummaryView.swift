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
                .font(.headline)
                .foregroundColor(.primary)
                .fontWeight(.medium)
            Spacer()
            Text("\(highTemp) / \(lowTemp)")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fontWeight(.light)
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}


struct DaySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        return DaySummaryView(day: "Monday", highTemp: "19", lowTemp: "16")
    }
}

//
//  ProgressViewWithText.swift
//  NagWeather
//
//  Created by Kartik Gupta on 14/01/25.
//

import SwiftUI

struct ProgressViewWithText: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 15) {
            ProgressView()
            Text(text)
        }
    }
}

#Preview {
    ProgressViewWithText(text: "Loading..")
}

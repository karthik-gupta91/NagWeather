//
//  BackgroundView.swift
//  NagWeather
//
//  Created by Kartik Gupta on 28/11/24.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient:
                            Gradient(colors: [
                                AppConstants.WeatherColor.AppBackground,
                                AppConstants.WeatherColor.AccentColor,
                            ]), startPoint: .top, endPoint: .bottomTrailing)

            VisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct BackgroundVIew_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}

#Preview {
    BackgroundView()
}

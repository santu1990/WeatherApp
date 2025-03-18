//
//  WeatherCard.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 17/03/25.
//

import SwiftUI

struct WeatherCard: View {
    let weather: WeatherResponse

    var body: some View {
        VStack(spacing: 5) {
            Text(weather.name)
                .font(.title)
                .fontWeight(.bold)

            Image(systemName: WeatherIconMapper.iconName(for: weather.weather.first!.icon))
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.yellow)
            Text("\(weather.main.temp, specifier: "%.1f")°C")
                .font(.title)
                .fontWeight(.semibold)

            Text(weather.weather.first?.description.capitalized ?? "--")
                .font(.title3)
                .foregroundColor(.gray)

            HStack(spacing: 20) {
                VStack {
                    Text("Humidity")
                        .font(.caption)
                    Text("\(weather.main.humidity)%")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                VStack {
                    Text("Wind")
                        .font(.caption)
                    Text("\(weather.wind.speed, specifier: "%.1f") m/s")
                        .font(.title3)
                        .fontWeight(.bold)
                }
            }
            .padding(.top, 5)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue.opacity(0.2))
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding()
    }
}

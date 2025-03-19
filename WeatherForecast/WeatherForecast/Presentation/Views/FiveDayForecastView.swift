//
//  FiveDayForecastView.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 18/03/25.
//

import SwiftUI
import Combine

struct FiveDayForecastView: View {
    @ObservedObject var forecastVM: ForecastViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("5-Day Forecast")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 5) {
                    ForEach(forecastVM.groupedForecast, id: \.0) { day, entries in
                        VStack(alignment: .leading) {
                            Text(day)
                                .font(.headline)
                                .bold()
                                .padding(.bottom, 5)

                            HStack {
                                if let firstEntry = entries.first {
                                    Image(systemName: WeatherIconMapper
                                        .iconName(for: firstEntry.weather.first?.icon ?? ""))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 35, height: 35)

                                    VStack(alignment: .leading) {
                                        Text("\(Int(firstEntry.main.temp))°C")
                                            .font(.title2)
                                            .bold()
                                        Text(firstEntry.weather.first?.description.capitalized ?? "--")
                                            .font(.subheadline)
                                    }

                                    Spacer()

                                    VStack {
                                        Text("Min: \(Int(firstEntry.main.tempMin))°C")
                                        Text("Max: \(Int(firstEntry.main.tempMax))°C")
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

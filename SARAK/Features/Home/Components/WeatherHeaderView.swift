// WeatherHeaderView.swift — SARAK
import SwiftUI

struct WeatherHeaderView: View {
    let weather: WeatherSummary?

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        return formatter.string(from: Date())
    }

    private var tempString: String {
        guard let weather else { return "--°C" }
        return String(format: "%.0f°C", weather.temperatureC)
    }

    private var moodString: String {
        guard let weather else { return "" }
        switch weather.condition {
        case .sunny:  return StringConstants.WeatherMood.sunny
        case .cloudy: return StringConstants.WeatherMood.cloudy
        case .rainy:  return StringConstants.WeatherMood.rainy
        case .snowy:  return StringConstants.WeatherMood.snowy
        case .unknown: return ""
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.sm) {
            Text(dateString)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            HStack(spacing: UIConstants.Spacing.sm) {
                Text(tempString)
                    .font(.headline)
                if !moodString.isEmpty {
                    Text(moodString)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, UIConstants.Spacing.md)
    }
}

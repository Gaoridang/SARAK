// WeatherHeaderView.swift — SARAK
import SwiftUI

struct WeatherHeaderView: View {
    let weather: WeatherSummary?

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.setLocalizedDateFormatFromTemplate("MdEEEE")
        return formatter.string(from: Date())
    }

    private var tempString: String {
        guard let weather else { return StringConstants.Home.weatherUnavailable }
        let measurement = Measurement(value: weather.temperatureC, unit: UnitTemperature.celsius)
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter.string(from: measurement)
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

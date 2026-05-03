// HomeHeaderView.swift — SARAK
import SwiftUI

struct HomeHeaderView: View {
    let weeklyMinutes: Int
    let weather: WeatherSummary?

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.setLocalizedDateFormatFromTemplate("EEEEMMMMd")
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
        case .sunny:   return StringConstants.WeatherMood.sunny
        case .cloudy:  return StringConstants.WeatherMood.cloudy
        case .rainy:   return StringConstants.WeatherMood.rainy
        case .snowy:   return StringConstants.WeatherMood.snowy
        case .unknown: return ""
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.sm) {
            Text(StringConstants.Home.greeting)
                .font(UIConstants.Typography.displayMD)
                .foregroundStyle(UIConstants.Colors.ink)
                .lineLimit(2)

            Text(String(format: StringConstants.Home.weeklyMinutesFormat, weeklyMinutes))
                .font(UIConstants.Typography.bodySM)
                .foregroundStyle(UIConstants.Colors.muted)

            weatherRow
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, UIConstants.Spacing.lg)
    }

    private var weatherRow: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.xxs) {
            HStack(spacing: UIConstants.Spacing.sm) {
                Text(dateString)
                    .lineLimit(1)
                Circle()
                    .fill(UIConstants.Colors.mutedSoft)
                    .frame(width: UIConstants.Size.separatorDot, height: UIConstants.Size.separatorDot)
                Text(tempString)
                    .lineLimit(1)
            }

            if !moodString.isEmpty {
                Text(moodString)
                    .lineLimit(2)
            }
        }
        .font(UIConstants.Typography.caption)
        .foregroundStyle(UIConstants.Colors.muted)
    }
}

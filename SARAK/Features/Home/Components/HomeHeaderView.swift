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
        VStack(alignment: .leading, spacing: UIConstants.Spacing.lg) {
            HStack {
                HStack(spacing: UIConstants.Spacing.xxs) {
                    dash(isActive: true)
                    dash(isActive: true)
                    dash(isActive: false)
                    dash(isActive: false)
                    dash(isActive: false)
                }

                Spacer()

                Button {} label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 16, weight: .medium))
                }
                .buttonStyle(IconCircleButtonStyle())
                .accessibilityHidden(true)
            }

            HStack(alignment: .center, spacing: UIConstants.Spacing.md) {
                VStack(alignment: .leading, spacing: UIConstants.Spacing.xxs) {
                    Text(StringConstants.Home.greeting)
                        .font(UIConstants.Typography.displayMD)
                        .foregroundStyle(UIConstants.Colors.ink)
                        .lineLimit(2)
                    Text(String(format: StringConstants.Home.weeklyMinutesFormat, weeklyMinutes))
                        .font(UIConstants.Typography.bodySM)
                        .foregroundStyle(UIConstants.Colors.muted)
                }

                Spacer(minLength: UIConstants.Spacing.md)

                Image(systemName: "person.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(UIConstants.Colors.onDark)
                    .frame(width: UIConstants.Size.avatar, height: UIConstants.Size.avatar)
                    .background(UIConstants.Colors.ink)
                    .clipShape(Circle())
                    .accessibilityHidden(true)
            }

            weatherRow
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, UIConstants.Spacing.lg)
    }

    private var weatherRow: some View {
        HStack(spacing: UIConstants.Spacing.sm) {
            Text(dateString)
                .lineLimit(1)
            Circle()
                .fill(UIConstants.Colors.mutedSoft)
                .frame(width: 3, height: 3)
            Text(tempString)
                .lineLimit(1)
            if !moodString.isEmpty {
                Text(moodString)
                    .lineLimit(1)
            }
        }
        .font(UIConstants.Typography.caption)
        .foregroundStyle(UIConstants.Colors.muted)
    }

    private func dash(isActive: Bool) -> some View {
        Capsule()
            .fill(isActive ? UIConstants.Colors.ink : UIConstants.Colors.divider)
            .frame(width: 22, height: 3)
    }
}

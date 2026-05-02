// WeatherSummary.swift — SARAK
import Foundation

struct WeatherSummary {
    let temperatureC: Double
    let condition: WeatherCondition
}

enum WeatherCondition {
    case sunny, cloudy, rainy, snowy, unknown
}

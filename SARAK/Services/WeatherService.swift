// WeatherService.swift — SARAK
import Foundation

protocol WeatherServiceProtocol: Sendable {
    func currentWeather() async throws -> WeatherSummary
}

struct StubWeatherService: WeatherServiceProtocol {
    func currentWeather() async throws -> WeatherSummary {
        WeatherSummary(temperatureC: 18, condition: .cloudy)
    }
}

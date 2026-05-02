// HomeViewModel.swift — SARAK
// Stub VM for PR 1. HomeBookDisplayModel and all hardcoded values replaced by
// real SwiftData models and repositories in PR 2.
import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var weather: WeatherSummary?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let weatherService: any WeatherServiceProtocol

    init(weatherService: any WeatherServiceProtocol = StubWeatherService()) {
        self.weatherService = weatherService
    }

    // MARK: - Stub data (replaced in PR 2)

    var weeklyMinutes: Int { 0 }

    var currentBook: HomeBookDisplayModel? {
        nil
    }

    var todayGoalMinutes: Int { 0 }
    var todayReadMinutes: Int { 0 }

    var queue: [HomeBookDisplayModel] {
        []
    }

    // MARK: - Weather

    func loadWeather() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            weather = try await weatherService.currentWeather()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

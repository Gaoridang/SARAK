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

    var weeklyMinutes: Int { 120 }

    var currentBook: HomeBookDisplayModel? {
        HomeBookDisplayModel(title: "Dune", author: "Frank Herbert", progress: 0.74)
    }

    var todayGoalMinutes: Int { 30 }
    var todayReadMinutes: Int { 20 }

    var queue: [HomeBookDisplayModel] {
        [
            HomeBookDisplayModel(title: "1984", author: "George Orwell", progress: 0.0),
            HomeBookDisplayModel(title: "The Alchemist", author: "Paulo Coelho", progress: 0.12),
            HomeBookDisplayModel(title: "Sapiens", author: "Yuval Noah Harari", progress: 0.0)
        ]
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

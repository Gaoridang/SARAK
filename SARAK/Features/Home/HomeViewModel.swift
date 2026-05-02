// HomeViewModel.swift — SARAK
// Stub VM for PR 1. StubBook and all hardcoded values replaced by real
// SwiftData models and repositories in PR 2.
import Foundation
import Combine

struct StubBook {
    let title: String
    let author: String
    let progress: Double  // 0.0 – 1.0
}

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var weather: WeatherSummary?
    @Published private(set) var isLoadingWeather = false

    private let weatherService: any WeatherServiceProtocol

    init(weatherService: any WeatherServiceProtocol = StubWeatherService()) {
        self.weatherService = weatherService
    }

    // MARK: - Stub data (replaced in PR 2)

    var weeklyMinutes: Int { 120 }

    var currentBook: StubBook? {
        StubBook(title: "Dune", author: "Frank Herbert", progress: 0.74)
    }

    var todayGoalMinutes: Int { 30 }
    var todayReadMinutes: Int { 20 }

    var queue: [StubBook] {
        [
            StubBook(title: "1984", author: "George Orwell", progress: 0.0),
            StubBook(title: "The Alchemist", author: "Paulo Coelho", progress: 0.12),
            StubBook(title: "Sapiens", author: "Yuval Noah Harari", progress: 0.0)
        ]
    }

    // MARK: - Weather

    func loadWeather() async {
        isLoadingWeather = true
        weather = try? await weatherService.currentWeather()
        isLoadingWeather = false
    }
}

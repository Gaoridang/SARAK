// HomeViewModelTests.swift — SARAK
import Testing
@testable import SARAK

@Suite("HomeViewModel")
@MainActor
struct HomeViewModelTests {

    @Test("stub weeklyMinutes returns non-negative value")
    func weeklyMinutesIsNonNegative() {
        let viewModel = HomeViewModel()
        #expect(viewModel.weeklyMinutes >= 0)
    }

    @Test("stub currentBook is non-nil")
    func currentBookIsNonNil() {
        let viewModel = HomeViewModel()
        #expect(viewModel.currentBook != nil)
    }

    @Test("stub todayGoalMinutes is greater than zero")
    func todayGoalMinutesIsPositive() {
        let viewModel = HomeViewModel()
        #expect(viewModel.todayGoalMinutes > 0)
    }

    @Test("stub queue is non-empty")
    func queueIsNonEmpty() {
        let viewModel = HomeViewModel()
        #expect(!viewModel.queue.isEmpty)
    }

    @Test("loadWeather sets weather to non-nil with stub service")
    func loadWeatherPopulatesWeather() async {
        let viewModel = HomeViewModel(weatherService: StubWeatherService())
        await viewModel.loadWeather()
        #expect(viewModel.weather != nil)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }

    @Test("loadWeather sets errorMessage on service failure")
    func loadWeatherSetsErrorOnFailure() async {
        let viewModel = HomeViewModel(weatherService: FailingWeatherService())
        await viewModel.loadWeather()
        #expect(viewModel.weather == nil)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.isLoading == false)
    }

    @Test("isLoading resets to false after loadWeather completes")
    func isLoadingResetsAfterLoad() async {
        let viewModel = HomeViewModel(weatherService: StubWeatherService())
        await viewModel.loadWeather()
        #expect(viewModel.isLoading == false)
    }
}

// MARK: - Fakes

private struct FailingWeatherService: WeatherServiceProtocol {
    func currentWeather() async throws -> WeatherSummary {
        throw WeatherTestError.intentional
    }
}

private enum WeatherTestError: Error {
    case intentional
}

// HomeViewModelTests.swift — SARAK
import Testing
@testable import SARAK

@Suite("HomeViewModel")
@MainActor
struct HomeViewModelTests {

    @Test("first-login weeklyMinutes is zero")
    func weeklyMinutesStartsAtZero() {
        let viewModel = HomeViewModel()
        #expect(viewModel.weeklyMinutes == 0)
    }

    @Test("first-login currentBook is nil")
    func currentBookStartsEmpty() {
        let viewModel = HomeViewModel()
        #expect(viewModel.currentBook == nil)
    }

    @Test("first-login goal and read minutes are zero")
    func goalAndReadMinutesStartAtZero() {
        let viewModel = HomeViewModel()
        #expect(viewModel.todayGoalMinutes == 0)
        #expect(viewModel.todayReadMinutes == 0)
    }

    @Test("first-login queue is empty")
    func queueStartsEmpty() {
        let viewModel = HomeViewModel()
        #expect(viewModel.queue.isEmpty)
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

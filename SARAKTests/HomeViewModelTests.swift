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
        #expect(viewModel.isLoadingWeather == false)
    }
}

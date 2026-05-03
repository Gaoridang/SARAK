// HomeViewModelTests.swift — SARAK
import SwiftData
import Testing
@testable import SARAK

@Suite("HomeViewModel")
@MainActor
struct HomeViewModelTests {

    @Test("first-login values are empty before local data exists")
    func firstLoginStartsEmpty() async throws {
        let viewModel = try makeViewModel()
        await viewModel.load()
        #expect(viewModel.weeklyMinutes == 0)
        #expect(viewModel.currentBook == nil)
        #expect(viewModel.todayGoalMinutes == 0)
        #expect(viewModel.todayReadMinutes == 0)
        #expect(viewModel.queue.isEmpty)
    }

    @Test("addBook populates current book")
    func addBookPopulatesCurrentBook() async throws {
        let viewModel = try makeViewModel()
        await viewModel.addBook(title: "Dune", author: "Frank Herbert")
        #expect(viewModel.currentBook?.title == "Dune")
        #expect(viewModel.errorMessage == nil)
    }

    @Test("setGoal updates today's goal minutes")
    func setGoalUpdatesTodayGoal() async throws {
        let viewModel = try makeViewModel()
        await viewModel.setGoal(minutes: 30)
        #expect(viewModel.todayGoalMinutes == 30)
    }

    @Test("toggleCurrentSession starts and stops session")
    func toggleCurrentSessionStartsAndStops() async throws {
        let viewModel = try makeViewModel()
        await viewModel.addBook(title: "Dune", author: "Frank Herbert")
        await viewModel.toggleCurrentSession()
        #expect(viewModel.activeSession != nil)
        await viewModel.toggleCurrentSession()
        #expect(viewModel.activeSession == nil)
        #expect(viewModel.todayReadMinutes >= 1)
    }

    @Test("loadWeather sets weather to non-nil with stub service")
    func loadWeatherPopulatesWeather() async throws {
        let viewModel = try makeViewModel(weatherService: StubWeatherService())
        await viewModel.loadWeather()
        #expect(viewModel.weather != nil)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }

    @Test("loadWeather sets errorMessage on service failure")
    func loadWeatherSetsErrorOnFailure() async throws {
        let viewModel = try makeViewModel(weatherService: FailingWeatherService())
        await viewModel.loadWeather()
        #expect(viewModel.weather == nil)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.isLoading == false)
    }

    private func makeViewModel(
        weatherService: (any WeatherServiceProtocol)? = nil
    ) throws -> HomeViewModel {
        let context = try TestModelContainerFactory.makeContext()
        return HomeViewModel(
            bookRepository: LocalBookRepository(modelContext: context),
            sessionRepository: LocalReadingSessionRepository(modelContext: context),
            goalRepository: LocalDailyGoalRepository(modelContext: context),
            weatherService: weatherService ?? StubWeatherService()
        )
    }
}

private struct FailingWeatherService: WeatherServiceProtocol {
    func currentWeather() async throws -> WeatherSummary {
        throw WeatherTestError.intentional
    }
}

private enum WeatherTestError: Error {
    case intentional
}

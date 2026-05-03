// HomeViewModel.swift — SARAK
import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var weather: WeatherSummary?
    @Published private(set) var books: [Book] = []
    @Published private(set) var sessions: [ReadingSession] = []
    @Published private(set) var todayGoal: DailyGoal?
    @Published private(set) var activeSession: ReadingSession?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let bookRepository: any BookRepositoryProtocol
    private let sessionRepository: any ReadingSessionRepositoryProtocol
    private let goalRepository: any DailyGoalRepositoryProtocol
    private let syncTrigger: (any SyncTriggerProtocol)?
    private let weatherService: any WeatherServiceProtocol

    init(
        bookRepository: any BookRepositoryProtocol,
        sessionRepository: any ReadingSessionRepositoryProtocol,
        goalRepository: any DailyGoalRepositoryProtocol,
        syncTrigger: (any SyncTriggerProtocol)? = nil,
        weatherService: (any WeatherServiceProtocol)? = nil
    ) {
        self.bookRepository = bookRepository
        self.sessionRepository = sessionRepository
        self.goalRepository = goalRepository
        self.syncTrigger = syncTrigger
        self.weatherService = weatherService ?? StubWeatherService()
    }

    var weeklyMinutes: Int {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return sessions
            .filter { $0.startedAt >= weekAgo }
            .reduce(0) { $0 + $1.durationMinutes }
    }

    var currentBook: HomeBookDisplayModel? {
        let book = books.first { $0.status == .reading } ?? books.first { $0.status == .queued }
        return book.map(displayModel)
    }

    var todayGoalMinutes: Int { todayGoal?.targetMinutes ?? 0 }

    var todayReadMinutes: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return sessions
            .filter { Calendar.current.startOfDay(for: $0.startedAt) == today }
            .reduce(0) { $0 + $1.durationMinutes }
    }

    var queue: [HomeBookDisplayModel] {
        books
            .filter { $0.status == .queued && $0.id != currentBook?.id }
            .map(displayModel)
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            books = try await bookRepository.fetchBooks()
            sessions = try await sessionRepository.fetchSessions()
            activeSession = try await sessionRepository.fetchActiveSession()
            todayGoal = try await goalRepository.goal(for: Date())
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addBook(title: String, author: String) async {
        await performAndReload {
            _ = try await bookRepository.addBook(title: title, author: author)
        }
    }

    func setGoal(minutes: Int) async {
        await performAndReload {
            _ = try await goalRepository.setGoal(minutes: minutes, for: Date())
        }
    }

    func toggleCurrentSession() async {
        guard let currentBook else { return }
        await performAndReload {
            if let activeSession {
                _ = try await sessionRepository.stopSession(id: activeSession.id)
            } else {
                if let book = books.first(where: { $0.id == currentBook.id }) {
                    book.status = .reading
                    try await bookRepository.updateBook(book)
                }
                _ = try await sessionRepository.startSession(bookID: currentBook.id)
            }
        }
    }

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

    private func performAndReload(_ action: () async throws -> Void) async {
        isLoading = true
        errorMessage = nil
        do {
            try await action()
            await load()
            triggerSync()
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    private func triggerSync() {
        guard let syncTrigger else { return }
        Task { await syncTrigger.syncPendingChanges() }
    }

    private func displayModel(for book: Book) -> HomeBookDisplayModel {
        HomeBookDisplayModel(id: book.id, title: book.title, author: book.author, progress: book.progress)
    }
}

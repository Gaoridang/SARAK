// StatsViewModel.swift — SARAK
import Foundation
import Combine

struct StatsSummary {
    let totalMinutes: Int
    let weeklyMinutes: Int
    let sessionCount: Int
    let finishedBooks: Int
}

@MainActor
final class StatsViewModel: ObservableObject {
    @Published private(set) var summary = StatsSummary(
        totalMinutes: 0,
        weeklyMinutes: 0,
        sessionCount: 0,
        finishedBooks: 0
    )
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let bookRepository: any BookRepositoryProtocol
    private let sessionRepository: any ReadingSessionRepositoryProtocol

    init(
        bookRepository: any BookRepositoryProtocol,
        sessionRepository: any ReadingSessionRepositoryProtocol
    ) {
        self.bookRepository = bookRepository
        self.sessionRepository = sessionRepository
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let books = try await bookRepository.fetchBooks()
            let sessions = try await sessionRepository.fetchSessions()
            let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            summary = StatsSummary(
                totalMinutes: sessions.reduce(0) { $0 + $1.durationMinutes },
                weeklyMinutes: sessions.filter { $0.startedAt >= weekAgo }.reduce(0) { $0 + $1.durationMinutes },
                sessionCount: sessions.count,
                finishedBooks: books.filter { $0.status == .finished }.count
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

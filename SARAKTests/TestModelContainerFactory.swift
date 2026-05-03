// TestModelContainerFactory.swift — SARAK
import SwiftData
@testable import SARAK

@MainActor
enum TestModelContainerFactory {
    static func makeContext() throws -> ModelContext {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: Book.self,
            ReadingSession.self,
            DailyGoal.self,
            PendingSyncChange.self,
            configurations: configuration
        )
        return ModelContext(container)
    }
}

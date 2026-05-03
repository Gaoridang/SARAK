// SyncCoordinator+RemoteImport.swift — SARAK
import Foundation
import os

extension SyncCoordinator {
    func importRemoteChanges() async {
        do {
            let bookPendingIDs = try await pendingRepository.pendingEntityIDs(for: .book)
            let sessionPendingIDs = try await pendingRepository.pendingEntityIDs(for: .readingSession)
            let goalPendingIDs = try await pendingRepository.pendingEntityIDs(for: .dailyGoal)
            let remoteBooks = try await remoteBookRepository.fetchBooks()
            try await bookMergeRepository.mergeRemoteBooks(
                remoteBooks,
                preservingPendingIDs: bookPendingIDs
            )
            let remoteSessions = try await remoteSessionRepository.fetchSessions()
            try await sessionMergeRepository.mergeRemoteSessions(
                remoteSessions,
                preservingPendingIDs: sessionPendingIDs
            )
            let remoteGoal = try await remoteGoalRepository.goal(for: Date())
            try await goalMergeRepository.mergeRemoteGoals(
                remoteGoal.map { [$0] } ?? [],
                preservingPendingIDs: goalPendingIDs
            )
        } catch {
            logger.error("Failed to import remote sync changes: \(error.localizedDescription)")
        }
    }
}

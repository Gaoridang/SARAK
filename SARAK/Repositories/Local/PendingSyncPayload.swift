// PendingSyncPayload.swift — SARAK
import Foundation

struct BookSyncPayload: Codable {
    let id: UUID
    let title: String
    let author: String
    let status: String
    let progress: Double
    let totalPages: Int?
    let currentPage: Int?
    let genre: String?
    let notes: String?
    let createdAt: Date
    let updatedAt: Date
    let deletedAt: Date?
}

struct ReadingSessionSyncPayload: Codable {
    let id: UUID
    let bookID: UUID
    let startedAt: Date
    let endedAt: Date?
    let durationMinutes: Int
    let createdAt: Date
    let updatedAt: Date
    let deletedAt: Date?
}

struct DailyGoalSyncPayload: Codable {
    let id: UUID
    let goalDate: Date
    let targetMinutes: Int
    let createdAt: Date
    let updatedAt: Date
}

// Book.swift — SARAK
import Foundation
import SwiftData

enum BookStatus: String, Codable, CaseIterable {
    case queued
    case reading
    case finished
}

@Model
final class Book {
    @Attribute(.unique) var id: UUID
    var title: String
    var author: String
    var statusRawValue: String
    var progress: Double
    var totalPages: Int?
    var currentPage: Int?
    var genre: String?
    var notes: String?
    var createdAt: Date
    var updatedAt: Date
    var lastSyncedAt: Date?
    var deletedAt: Date?

    var status: BookStatus {
        get { BookStatus(rawValue: statusRawValue) ?? .queued }
        set { statusRawValue = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        title: String,
        author: String,
        status: BookStatus = .queued,
        progress: Double = 0,
        totalPages: Int? = nil,
        currentPage: Int? = nil,
        genre: String? = nil,
        notes: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        lastSyncedAt: Date? = nil,
        deletedAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.statusRawValue = status.rawValue
        self.progress = progress
        self.totalPages = totalPages
        self.currentPage = currentPage
        self.genre = genre
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastSyncedAt = lastSyncedAt
        self.deletedAt = deletedAt
    }
}

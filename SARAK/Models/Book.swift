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
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastSyncedAt = lastSyncedAt
        self.deletedAt = deletedAt
    }
}

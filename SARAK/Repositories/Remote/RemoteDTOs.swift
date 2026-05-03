// RemoteDTOs.swift — SARAK
import Foundation

struct BookRemoteDTO: Codable {
    let id: UUID
    let userID: UUID
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

    // Default nil for optional fields keeps existing callers (e.g. SyncCoordinator) compatible.
    init(
        id: UUID, userID: UUID, title: String, author: String,
        status: String, progress: Double,
        totalPages: Int? = nil, currentPage: Int? = nil,
        genre: String? = nil, notes: String? = nil,
        createdAt: Date, updatedAt: Date, deletedAt: Date?
    ) {
        self.id = id; self.userID = userID; self.title = title; self.author = author
        self.status = status; self.progress = progress
        self.totalPages = totalPages; self.currentPage = currentPage
        self.genre = genre; self.notes = notes
        self.createdAt = createdAt; self.updatedAt = updatedAt; self.deletedAt = deletedAt
    }

    enum CodingKeys: String, CodingKey {
        case id, title, author, status, progress, genre, notes
        case userID = "user_id"
        case totalPages = "total_pages"
        case currentPage = "current_page"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }

    func toDomain() -> Book {
        Book(
            id: id,
            title: title,
            author: author,
            status: BookStatus(rawValue: status) ?? .queued,
            progress: progress,
            totalPages: totalPages,
            currentPage: currentPage,
            genre: genre,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt
        )
    }
}

struct ReadingSessionRemoteDTO: Codable {
    let id: UUID
    let userID: UUID
    let bookID: UUID
    let startedAt: Date
    let endedAt: Date?
    let durationMinutes: Int
    let createdAt: Date
    let updatedAt: Date
    let deletedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case bookID = "book_id"
        case startedAt = "started_at"
        case endedAt = "ended_at"
        case durationMinutes = "duration_minutes"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }

    func toDomain() -> ReadingSession {
        ReadingSession(
            id: id,
            bookID: bookID,
            startedAt: startedAt,
            endedAt: endedAt,
            durationMinutes: durationMinutes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt
        )
    }
}

struct DailyGoalRemoteDTO: Codable {
    let id: UUID
    let userID: UUID
    let goalDate: Date
    let targetMinutes: Int
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case goalDate = "goal_date"
        case targetMinutes = "target_minutes"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    func toDomain() -> DailyGoal {
        DailyGoal(
            id: id,
            goalDate: goalDate,
            targetMinutes: targetMinutes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

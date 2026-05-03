// RemoteDTOs.swift — SARAK
import Foundation

struct BookRemoteDTO: Codable {
    let id: UUID
    let userID: UUID
    let title: String
    let author: String
    let status: String
    let progress: Double
    let createdAt: Date
    let updatedAt: Date
    let deletedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case title
        case author
        case status
        case progress
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

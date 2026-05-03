// LocalRepositoryError.swift — SARAK
import Foundation

enum LocalRepositoryError: LocalizedError {
    case notFound
    case invalidInput
    case encodingFailed

    var errorDescription: String? {
        switch self {
        case .notFound:
            String(localized: "error.item_not_found")
        case .invalidInput:
            String(localized: "error.invalid_input")
        case .encodingFailed:
            String(localized: "error.sync_payload_failed")
        }
    }
}

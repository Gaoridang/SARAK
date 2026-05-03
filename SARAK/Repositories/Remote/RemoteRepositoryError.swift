// RemoteRepositoryError.swift — SARAK
import Foundation

enum RemoteRepositoryError: LocalizedError {
    case signedOut

    var errorDescription: String? {
        switch self {
        case .signedOut:
            String(localized: "error.signed_out")
        }
    }
}

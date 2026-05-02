// APIConstants.swift — SARAK
// All API keys, table names, and identifiers live here.
// Never hardcode strings in Views or ViewModels.
import Foundation

enum APIConstants {
    enum Supabase {
        static let url = "https://lloiugyxirlqifjlgpso.supabase.co"
        static let anonKey = "sb_publishable_vcVngNY4O2r9PXE_8-zsfg_TFiKFRaw"
        static let booksTable = "books"
        static let sessionsTable = "reading_sessions"
        static let goalsTable = "goals"
        static let notesTable = "notes"
    }
    enum Auth {
        static let redirectURL: URL = {
            guard let url = URL(string: "sarak://auth/callback") else {
                preconditionFailure("Invalid OAuth redirect URL — check APIConstants.Auth.redirectURL")
            }
            return url
        }()
    }
}

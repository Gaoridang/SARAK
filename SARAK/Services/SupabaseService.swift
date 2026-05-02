// SupabaseService.swift — SARAK
// Single shared SupabaseClient instance. Only place import Supabase is
// allowed outside Remote*Repository files. See .harness/supabase.md.
import Supabase
import Foundation

enum SupabaseService {
    static let client: SupabaseClient = {
        guard let url = URL(string: APIConstants.Supabase.url) else {
            preconditionFailure("Invalid Supabase URL — check APIConstants.Supabase.url")
        }
        return SupabaseClient(supabaseURL: url, supabaseKey: APIConstants.Supabase.anonKey)
    }()
}

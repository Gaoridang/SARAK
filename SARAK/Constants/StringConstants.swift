// StringConstants.swift — SARAK
// Localized string keys for all user-facing text.
// Never hardcode display strings in Views or ViewModels.
import Foundation

enum StringConstants {
    enum Common {
        static let cancel = String(localized: "common.cancel")
        static let save = String(localized: "common.save")
    }

    enum Auth {
        static let appTitle = String(localized: "auth.app_title")
        static let kakaoLoginButton = String(localized: "auth.kakao_login_button")
        static let signOutButton = String(localized: "auth.sign_out_button")
    }

    enum Tab {
        static let home = String(localized: "tab.home")
        static let library = String(localized: "tab.library")
        static let stats = String(localized: "tab.stats")
        static let profile = String(localized: "tab.profile")
    }

    enum Home {
        static let greeting = String(localized: "home.greeting")
        static let weeklyMinutesFormat = String(localized: "home.weekly_minutes_format")
        static let progressFormat = String(localized: "home.progress_format")
        static let startSession = String(localized: "home.start_session")
        static let stopSession = String(localized: "home.stop_session")
        static let noCurrentBook = String(localized: "home.no_current_book")
        static let addBook = String(localized: "home.add_book")
        static let goalProgressFormat = String(localized: "home.goal_progress_format")
        static let dailyGoalLabel = String(localized: "home.daily_goal_label")
        static let noGoalSet = String(localized: "home.no_goal_set")
        static let setGoal = String(localized: "home.set_goal")
        static let readingQueue = String(localized: "home.reading_queue")
        static let emptyQueue = String(localized: "home.empty_queue")
        static let weatherUnavailable = String(localized: "home.weather.unavailable")
    }

    enum Book {
        static let addTitle = String(localized: "book.add_title")
        static let titlePlaceholder = String(localized: "book.title_placeholder")
        static let authorPlaceholder = String(localized: "book.author_placeholder")
    }

    enum Goal {
        static let setTitle = String(localized: "goal.set_title")
        static let minutesFormat = String(localized: "goal.minutes_format")
    }

    enum Library {
        static let empty = String(localized: "library.empty")
    }

    enum Stats {
        static let totalMinutes = String(localized: "stats.total_minutes")
        static let weeklyMinutes = String(localized: "stats.weekly_minutes")
        static let sessions = String(localized: "stats.sessions")
        static let finishedBooks = String(localized: "stats.finished_books")
    }

    enum WeatherMood {
        static let sunny = String(localized: "home.mood.sunny")
        static let cloudy = String(localized: "home.mood.cloudy")
        static let rainy = String(localized: "home.mood.rainy")
        static let snowy = String(localized: "home.mood.snowy")
    }

    enum Error {
        static let itemNotFound = String(localized: "error.item_not_found")
        static let invalidInput = String(localized: "error.invalid_input")
        static let syncPayloadFailed = String(localized: "error.sync_payload_failed")
        static let signedOut = String(localized: "error.signed_out")
    }
}

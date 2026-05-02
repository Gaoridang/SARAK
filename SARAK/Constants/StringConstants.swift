// StringConstants.swift — SARAK
// Localized string keys for all user-facing text.
// Never hardcode display strings in Views or ViewModels.
import Foundation

enum StringConstants {
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

    enum WeatherMood {
        static let sunny = String(localized: "home.mood.sunny")
        static let cloudy = String(localized: "home.mood.cloudy")
        static let rainy = String(localized: "home.mood.rainy")
        static let snowy = String(localized: "home.mood.snowy")
    }
}

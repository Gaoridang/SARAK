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
        static let emptyWelcome = String(localized: "home.empty.welcome")
        static let emptyDayFormat = String(localized: "home.empty.day_format")
        static let emptyStepLabel = String(localized: "home.empty.step_label")
        static let emptyHeroTitle = String(localized: "home.empty.hero_title")
        static let emptyHeroBody = String(localized: "home.empty.hero_body")
        static let emptySetupProgress = String(localized: "home.empty.setup_progress")
        static let emptyAddBookCTA = String(localized: "home.empty.add_book_cta")
        static let emptySetupTitle = String(localized: "home.empty.setup_title")
        static let emptySetupCount = String(localized: "home.empty.setup_count")
        static let emptyStepOneTitle = String(localized: "home.empty.step_one_title")
        static let emptyStepOneSubtitle = String(localized: "home.empty.step_one_subtitle")
        static let emptyStepTwoTitle = String(localized: "home.empty.step_two_title")
        static let emptyStepTwoSubtitle = String(localized: "home.empty.step_two_subtitle")
        static let emptyStepThreeTitle = String(localized: "home.empty.step_three_title")
        static let emptyStepThreeSubtitle = String(localized: "home.empty.step_three_subtitle")
        static let weeklyMinutesFormat = String(localized: "home.weekly_minutes_format")
        static let progressFormat = String(localized: "home.progress_format")
        static let startSession = String(localized: "home.start_session")
        static let stopSession = String(localized: "home.stop_session")
        static let continueReading = String(localized: "home.continue_reading")
        static let noCurrentBook = String(localized: "home.no_current_book")
        static let addBook = String(localized: "home.add_book")
        static let goalProgressFormat = String(localized: "home.goal_progress_format")
        static let dailyGoalLabel = String(localized: "home.daily_goal_label")
        static let yourGoals = String(localized: "home.your_goals")
        static let editGoal = String(localized: "home.edit_goal")
        static let pageProgressFormat = String(localized: "home.page_progress_format")
        static let upNextFormat = String(localized: "home.up_next_format")
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
        static let totalPagesPlaceholder = String(localized: "book.total_pages_placeholder")
        static let genrePlaceholder = String(localized: "book.genre_placeholder")
        static let notesPlaceholder = String(localized: "book.notes_placeholder")
    }

    enum Goal {
        static let setTitle = String(localized: "goal.set_title")
        static let minutesFormat = String(localized: "goal.minutes_format")
    }

    enum Library {
        static let empty = String(localized: "library.empty")
        static let addBook = String(localized: "library.add_book")
        static let countFormat = String(localized: "library.count_format")
        static let tabAll = String(localized: "library.tab.all")
        static let tabReading = String(localized: "library.tab.reading")
        static let tabFinished = String(localized: "library.tab.finished")
        static let tabWantToRead = String(localized: "library.tab.want_to_read")
        static let emptyTitle = String(localized: "library.empty.title")
        static let emptyBody = String(localized: "library.empty.body")
        static let scanISBN = String(localized: "library.scan_isbn")
        static let statusQueued = String(localized: "library.status.queued")
        static let statusReading = String(localized: "library.status.reading")
        static let statusFinished = String(localized: "library.status.finished")
    }

    enum BookDetail {
        static let startReading = String(localized: "book_detail.start_reading")
        static let markFinished = String(localized: "book_detail.mark_finished")
        static let readAgain = String(localized: "book_detail.read_again")
        static let editInfo = String(localized: "book_detail.edit_info")
        static let deleteBook = String(localized: "book_detail.delete_book")
        static let deleteConfirmTitle = String(localized: "book_detail.delete_confirm_title")
        static let deleteConfirmMessage = String(localized: "book_detail.delete_confirm_message")
        static let delete = String(localized: "book_detail.delete")
        static let progressLabel = String(localized: "book_detail.progress_label")
        static let addedLabel = String(localized: "book_detail.added_label")
        static let editTitle = String(localized: "book_detail.edit_title")
        static let titleLabel = String(localized: "book_detail.title_label")
        static let authorLabel = String(localized: "book_detail.author_label")
        static let pagesLabel = String(localized: "book_detail.pages_label")
        static let pagesFormat = String(localized: "book_detail.pages_format")
        static let genreLabel = String(localized: "book_detail.genre_label")
        static let notesLabel = String(localized: "book_detail.notes_label")
        static let totalPagesLabel = String(localized: "book_detail.total_pages_label")
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

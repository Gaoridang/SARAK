// MainTabView.swift — SARAK
import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var authViewModel: AuthViewModel
    @State private var selectedTab = AppTab.initial

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(
                viewModel: HomeViewModel(
                    bookRepository: bookRepository,
                    sessionRepository: sessionRepository,
                    goalRepository: goalRepository,
                    syncTrigger: syncCoordinator
                )
            )
                .tabItem {
                    Label(StringConstants.Tab.home, systemImage: "house.fill")
                }
                .tag(AppTab.home)

            LibraryView(
                viewModel: LibraryViewModel(
                    bookRepository: bookRepository,
                    syncTrigger: syncCoordinator
                )
            )
                .tabItem {
                    Label(StringConstants.Tab.library, systemImage: "books.vertical.fill")
                }
                .tag(AppTab.library)

            StatsView(
                viewModel: StatsViewModel(
                    bookRepository: bookRepository,
                    sessionRepository: sessionRepository
                )
            )
                .tabItem {
                    Label(StringConstants.Tab.stats, systemImage: "chart.bar.fill")
                }
                .tag(AppTab.stats)

            ProfileView(authViewModel: authViewModel)
                .tabItem {
                    Label(StringConstants.Tab.profile, systemImage: "person.fill")
                }
                .tag(AppTab.profile)
        }
        .task {
            await syncCoordinator.syncAfterLogin()
        }
    }

    private var bookRepository: LocalBookRepository {
        LocalBookRepository(modelContext: modelContext)
    }

    private var sessionRepository: LocalReadingSessionRepository {
        LocalReadingSessionRepository(modelContext: modelContext)
    }

    private var goalRepository: LocalDailyGoalRepository {
        LocalDailyGoalRepository(modelContext: modelContext)
    }

    private var syncCoordinator: SyncCoordinator {
        SyncCoordinator(
            pendingRepository: LocalPendingSyncRepository(modelContext: modelContext),
            bookMergeRepository: bookRepository,
            sessionMergeRepository: sessionRepository,
            goalMergeRepository: goalRepository,
            remoteBookRepository: RemoteBookRepository(),
            remoteSessionRepository: RemoteReadingSessionRepository(),
            remoteGoalRepository: RemoteDailyGoalRepository()
        )
    }
}

private enum AppTab {
    case home
    case library
    case stats
    case profile

    static var initial: AppTab {
        #if DEBUG
        if ProcessInfo.processInfo.environment["SARAK_SCREENSHOT_INITIAL_TAB"] == "library" {
            return .library
        }
        #endif
        return .home
    }
}

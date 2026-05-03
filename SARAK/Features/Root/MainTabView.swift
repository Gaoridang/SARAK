// MainTabView.swift — SARAK
import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        TabView {
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

            LibraryView(
                viewModel: LibraryViewModel(
                    bookRepository: bookRepository,
                    syncTrigger: syncCoordinator
                )
            )
                .tabItem {
                    Label(StringConstants.Tab.library, systemImage: "books.vertical.fill")
                }

            StatsView(
                viewModel: StatsViewModel(
                    bookRepository: bookRepository,
                    sessionRepository: sessionRepository
                )
            )
                .tabItem {
                    Label(StringConstants.Tab.stats, systemImage: "chart.bar.fill")
                }

            ProfileView(authViewModel: authViewModel)
                .tabItem {
                    Label(StringConstants.Tab.profile, systemImage: "person.fill")
                }
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
        SyncCoordinator(pendingRepository: LocalPendingSyncRepository(modelContext: modelContext))
    }
}

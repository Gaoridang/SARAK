// MainTabView.swift — SARAK
import SwiftUI

struct MainTabView: View {
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label(StringConstants.Tab.home, systemImage: "house.fill")
                }

            LibraryView()
                .tabItem {
                    Label(StringConstants.Tab.library, systemImage: "books.vertical.fill")
                }

            StatsView()
                .tabItem {
                    Label(StringConstants.Tab.stats, systemImage: "chart.bar.fill")
                }

            ProfileView(authViewModel: authViewModel)
                .tabItem {
                    Label(StringConstants.Tab.profile, systemImage: "person.fill")
                }
        }
    }
}

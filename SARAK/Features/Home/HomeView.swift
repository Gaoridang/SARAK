// HomeView.swift — SARAK
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.lg) {
                ProfileStripView(weeklyMinutes: viewModel.weeklyMinutes)
                WeatherHeaderView(weather: viewModel.weather)
                CurrentlyReadingCard(book: viewModel.currentBook)
                HStack {
                    Spacer()
                    DailyGoalRing(
                        todayReadMinutes: viewModel.todayReadMinutes,
                        todayGoalMinutes: viewModel.todayGoalMinutes
                    )
                    Spacer()
                }
                .padding(.horizontal, UIConstants.Spacing.md)
                ReadingQueueStrip(books: viewModel.queue)
            }
            .padding(.vertical, UIConstants.Spacing.md)
        }
        .task {
            await viewModel.loadWeather()
        }
    }
}

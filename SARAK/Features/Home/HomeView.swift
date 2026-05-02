// HomeView.swift — SARAK
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.xxl) {
                topBand
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
        .background(UIConstants.Colors.canvas)
        .task {
            await viewModel.loadWeather()
        }
    }

    private var topBand: some View {
        ZStack(alignment: .topTrailing) {
            RadialGradient(
                colors: [UIConstants.Colors.gradientMint.opacity(0.45), .clear],
                center: .center,
                startRadius: 0,
                endRadius: 180
            )
            .frame(width: 360, height: 360)
            .blur(radius: 60)
            .offset(x: UIConstants.Spacing.xxl, y: -UIConstants.Spacing.section)
            .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: UIConstants.Spacing.md) {
                ProfileStripView(weeklyMinutes: viewModel.weeklyMinutes)
                WeatherHeaderView(weather: viewModel.weather)
            }
        }
    }
}

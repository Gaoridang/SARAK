// HomeView.swift — SARAK
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.lg) {
                topBand
                CurrentlyReadingCard(book: viewModel.currentBook)
                dailyGoalSection
                ReadingQueueStrip(books: viewModel.queue)
            }
            .padding(.top, UIConstants.Spacing.lg)
            .padding(.bottom, UIConstants.Spacing.section)
        }
        .background(UIConstants.Colors.canvas)
        .task {
            await viewModel.loadWeather()
        }
    }

    private var topBand: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.md) {
            ProfileStripView(weeklyMinutes: viewModel.weeklyMinutes)
            WeatherHeaderView(weather: viewModel.weather)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(alignment: .topTrailing) {
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
        }
    }

    private var dailyGoalSection: some View {
        HStack {
            Spacer()
            DailyGoalRing(
                todayReadMinutes: viewModel.todayReadMinutes,
                todayGoalMinutes: viewModel.todayGoalMinutes
            )
            Spacer()
        }
        .padding(UIConstants.Spacing.lg)
        .background(UIConstants.Colors.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.lg)
                .stroke(UIConstants.Colors.hairline, lineWidth: 1)
        )
        .padding(.horizontal, UIConstants.Spacing.md)
    }
}

// HomeView.swift — SARAK
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var isShowingAddBook = false
    @State private var isShowingSetGoal = false

    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.lg) {
                topBand
                CurrentlyReadingCard(
                    book: viewModel.currentBook,
                    isSessionActive: viewModel.activeSession != nil,
                    onAddBook: { isShowingAddBook = true },
                    onToggleSession: {
                        Task { await viewModel.toggleCurrentSession() }
                    }
                )
                dailyGoalSection
                ReadingQueueStrip(books: viewModel.queue) {
                    isShowingAddBook = true
                }
            }
            .padding(.top, UIConstants.Spacing.lg)
            .padding(.bottom, UIConstants.Spacing.section)
        }
        .background(UIConstants.Colors.canvas)
        .task {
            await viewModel.load()
            await viewModel.loadWeather()
        }
        .sheet(isPresented: $isShowingAddBook) {
            AddBookView { title, author in
                await viewModel.addBook(title: title, author: author)
            }
        }
        .sheet(isPresented: $isShowingSetGoal) {
            SetGoalView { minutes in
                await viewModel.setGoal(minutes: minutes)
            }
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
        Group {
            if viewModel.todayGoalMinutes == 0 {
                DailyGoalRing(
                    todayReadMinutes: viewModel.todayReadMinutes,
                    todayGoalMinutes: viewModel.todayGoalMinutes,
                    onSetGoal: { isShowingSetGoal = true }
                )
            } else {
                HStack {
                    Spacer()
                    DailyGoalRing(
                        todayReadMinutes: viewModel.todayReadMinutes,
                        todayGoalMinutes: viewModel.todayGoalMinutes,
                        onSetGoal: { isShowingSetGoal = true }
                    )
                    Spacer()
                }
                .compactCard()
            }
        }
        .padding(.horizontal, UIConstants.Spacing.md)
    }
}

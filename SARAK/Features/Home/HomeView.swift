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
            Group {
                if viewModel.books.isEmpty {
                    HomeEmptyOnboardingView {
                        isShowingAddBook = true
                    }
                } else {
                    populatedContent
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
            AddBookView { title, author, totalPages, genre in
                await viewModel.addBook(
                    title: title, author: author, totalPages: totalPages, genre: genre
                )
            }
        }
        .sheet(isPresented: $isShowingSetGoal) {
            SetGoalView { minutes in
                await viewModel.setGoal(minutes: minutes)
            }
        }
    }

    private var populatedContent: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.lgx) {
            HomeHeaderView(weeklyMinutes: viewModel.weeklyMinutes, weather: viewModel.weather)
            CurrentlyReadingCard(
                book: viewModel.currentBook,
                isSessionActive: viewModel.activeSession != nil,
                onAddBook: { isShowingAddBook = true },
                onToggleSession: {
                    Task { await viewModel.toggleCurrentSession() }
                }
            )
            goalsSection
            ReadingQueueStrip(books: viewModel.queue) {
                isShowingAddBook = true
            }
        }
    }

    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.sm) {
            HStack(alignment: .firstTextBaseline) {
                Text(StringConstants.Home.yourGoals)
                    .font(UIConstants.Typography.titleSM)
                    .foregroundStyle(UIConstants.Colors.ink)
                Spacer()
                Button(StringConstants.Home.editGoal) {
                    isShowingSetGoal = true
                }
                .font(UIConstants.Typography.caption)
                .foregroundStyle(UIConstants.Colors.muted)
            }

            DailyGoalRing(
                todayReadMinutes: viewModel.todayReadMinutes,
                todayGoalMinutes: viewModel.todayGoalMinutes,
                onSetGoal: { isShowingSetGoal = true }
            )
        }
        .padding(.horizontal, UIConstants.Spacing.lg)
    }
}

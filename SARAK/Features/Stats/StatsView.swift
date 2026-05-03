// StatsView.swift — SARAK
import SwiftUI

struct StatsView: View {
    @StateObject private var viewModel: StatsViewModel

    init(viewModel: StatsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                statRow(title: StringConstants.Stats.totalMinutes, value: "\(viewModel.summary.totalMinutes)")
                statRow(title: StringConstants.Stats.weeklyMinutes, value: "\(viewModel.summary.weeklyMinutes)")
                statRow(title: StringConstants.Stats.sessions, value: "\(viewModel.summary.sessionCount)")
                statRow(title: StringConstants.Stats.finishedBooks, value: "\(viewModel.summary.finishedBooks)")
            }
                .navigationTitle(StringConstants.Tab.stats)
        }
        .task { await viewModel.load() }
    }

    private func statRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .font(UIConstants.Typography.bodyStrong)
                .foregroundStyle(UIConstants.Colors.ink)
        }
    }
}

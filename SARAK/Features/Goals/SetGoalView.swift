// SetGoalView.swift — SARAK
import SwiftUI

struct SetGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var minutes = 20
    let onSave: (Int) async -> Void

    var body: some View {
        NavigationStack {
            Form {
                Stepper(
                    String(format: StringConstants.Goal.minutesFormat, minutes),
                    value: $minutes,
                    in: 5...240,
                    step: 5
                )
            }
            .navigationTitle(StringConstants.Goal.setTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(StringConstants.Common.cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(StringConstants.Common.save) {
                        Task {
                            await onSave(minutes)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

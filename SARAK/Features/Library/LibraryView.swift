// LibraryView.swift — SARAK
import SwiftUI

struct LibraryView: View {
    var body: some View {
        NavigationStack {
            Text(StringConstants.Tab.library)
                .navigationTitle(StringConstants.Tab.library)
        }
    }
}

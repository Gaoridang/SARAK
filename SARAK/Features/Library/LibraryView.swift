// LibraryView.swift — SARAK
import SwiftUI

struct LibraryView: View {
    var body: some View {
        NavigationStack {
            Text("내 서재")
                .navigationTitle(StringConstants.Tab.library)
        }
    }
}

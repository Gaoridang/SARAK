//
//  SARAKApp.swift
//  SARAK
//
//  Created by ijaejun on 5/2/26.
//

import SwiftUI
import SwiftData

@main
struct SARAKApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [
            Book.self,
            ReadingSession.self,
            DailyGoal.self,
            PendingSyncChange.self
        ])
    }
}

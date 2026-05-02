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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .onOpenURL { url in
                    SupabaseService.handle(url)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}

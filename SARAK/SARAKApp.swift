//
//  SARAKApp.swift
//  SARAK
//
//  Created by ijaejun on 5/2/26.
//

import SwiftUI

@main
struct SARAKApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .onOpenURL { url in
                    SupabaseService.handle(url)
                }
        }
    }
}

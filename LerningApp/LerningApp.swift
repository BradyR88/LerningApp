//
//  LerningApp.swift
//  LerningApp
//
//  Created by Brady Robshaw on 1/15/22.
//

import SwiftUI

@main
struct LerningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}

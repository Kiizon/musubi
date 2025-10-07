//
//  musubiApp.swift
//  musubi
//
//  Created by Kish Dizon on 2025-10-07.
//

import SwiftUI

@main
struct musubiApp: App {
    var body: some Scene {
        MenuBarExtra("Musubi", systemImage: "timer") {
            ContentView().frame(width: 240, height: 100)
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .menuBarExtraStyle(.window)
    }
}

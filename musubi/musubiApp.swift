//
//  musubiApp.swift
//  musubi
//
//  Created by Kish Dizon on 2025-10-07.
//

import SwiftUI

@main
struct musubiApp: App {
    @StateObject private var vm = TimerViewModel(minutes: 25)
    
    var body: some Scene {
        MenuBarExtra{
            ContentView()
                .environmentObject(vm)
                .frame(width: 300, height: 100)
            
            Divider()
            
        } label: {
            Text(formatTime(vm.remainingTime))
        }
        .menuBarExtraStyle(.window)
    }
}

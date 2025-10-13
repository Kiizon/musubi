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
                .frame(width: 250, height: 140)
            
            
        } label: {
            pillTemplateImage(formatTime(vm.remainingTime))
        }
        .menuBarExtraStyle(.window)
    }
}
func pillTemplateImage(_ text: String) -> Image {
    let pill = Text(text)
        .font(.system(size: 12, weight: .semibold))
        .frame(width: 40, height: 15)
        .padding(.horizontal, 6)
        .padding(.vertical, 1)
        .overlay(
            RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                .opacity(0.1)
        )
        .padding(1)

    let r = ImageRenderer(content: pill)
    r.scale = NSScreen.main?.backingScaleFactor ?? 2

    guard let ns = r.nsImage else { return Image(systemName: "timer") }
    ns.isTemplate = true
    return Image(nsImage: ns).renderingMode(.template)
}

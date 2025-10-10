//
//  ContentView.swift
//  musubi
//
//  Created by Kish Dizon on 2025-10-07.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var timeRemaining = 7200
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(formatTime(timeRemaining))
                .onReceive(timer) { _ in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    }
                }
        }
        .padding()
    }
}

func formatTime(_ seconds: Int) -> String {
    let remainingHours = seconds / 3600
    let remainingMinutes = (seconds % remainingHours) / 60
    let remainingSeconds = seconds.remainderReportingOverflow(dividingBy: 60).partialValue
    return String(format: "%02d:%02d:%02d", remainingHours, remainingMinutes, remainingSeconds)
}

#Preview {
    ContentView()
}

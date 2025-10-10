//
//  ContentView.swift
//  musubi
//
//  Created by Kish Dizon on 2025-10-07.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = TimerViewModel(minutes: 25)
    @State private var sliderMinutes: Double = 25

    var body: some View {
        VStack {
            
            VStack(alignment: .leading) {
                Text("Duration: \(Int(sliderMinutes)) min")
                Slider(value: $sliderMinutes, in: 1...120, step: 1)
                    .onChange(of: sliderMinutes) { oldValue, newValue in
                        vm.setDuration(minutes: Int(newValue))
                    }
            }
            
            Text(formatTime(vm.remainingTime))
                .monospacedDigit()

            Button(vm.state == .running ? "Pause" : "Start") {
                vm.state == .running ? vm.pause() : vm.start()
            }
            .buttonStyle(.borderedProminent)

            Text(label(for: vm.state))
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .onDisappear { vm.pause() }
    }

    private func label(for state: TimerViewModel.State) -> String {
        switch state {
        case .idle: return "Idle"
        case .running: return "Running"
        case .paused: return "Paused"
        case .finished: return "Finished"
        }
    }
}

#Preview { ContentView() }

//
//  ContentView.swift
//  musubi
//
//  Created by Kish Dizon on 2025-10-07.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm : TimerViewModel
    @State private var sliderMinutes: Double = 25

    var body: some View {
        VStack {
            
            VStack(alignment: .leading) {
                Slider(value: $sliderMinutes, in: 0...120, step: 1)
                    .onChange(of: sliderMinutes) { oldValue, newValue in
                        vm.setDuration(minutes: Int(newValue))
                    }
                
                HStack {
                    Button("5m") {
                        vm.setDuration(minutes: 5)
                        if vm.state == .running {
                            vm.pause()
                        } else {
                            vm.start()
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Button("10m") {
                        vm.setDuration(minutes: 10)
                        if vm.state == .running {
                            vm.pause()
                        } else {
                            vm.start()
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Button("25m") {
                        vm.setDuration(minutes: 25)
                        if vm.state == .running {
                            vm.pause()
                        } else {
                            vm.start()
                        }
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    Button {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                HStack {
                    Button(vm.state == .running ? "Pause" : "Start"){
                        if vm.state == .running {
                            vm.pause()
                        } else {
                            vm.start()
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(vm.remainingTime == 0)
                    
                    Spacer()
                    
                    Text(formatTime(vm.remainingTime))
                        .monospacedDigit()
                        .font(Font.largeTitle.monospacedDigit())
                    
                }
            }
        }
        .padding()
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

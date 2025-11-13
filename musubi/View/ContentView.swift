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
    
    @State private var showPopover = false
    @AppStorage("showFloatingDisplay") private var showFloatingDisplay = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Slider(value: $sliderMinutes, in: 0...120, step: 1)
                .onChange(of: sliderMinutes) { oldValue, newValue in
                    vm.setDuration(minutes: Int(newValue))
                }
            
            HStack {
                Button("5m")  { setAndToggle(5)  }
                    .buttonStyle(.plain)
                    .hoverBackground()
                
                Button("10m") { setAndToggle(10) }
                    .buttonStyle(.plain)
                    .hoverBackground()
                
                Button("25m") { setAndToggle(25) }
                    .buttonStyle(.plain)
                    .hoverBackground()
                
                Spacer()
                
                Button {
                    showPopover.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .hoverBackground()
                }
                .buttonStyle(.plain)
                .popover(isPresented: $showPopover,attachmentAnchor: .rect(.bounds),arrowEdge: .top) {
                    PopoverMenu(
                        showPopover: $showPopover,
                        showFloatingDisplay: $showFloatingDisplay
                    )
                    .frame(width: 150)
                    .padding(8)
                }
            }
            
            Spacer()
            
            HStack {
                Button(vm.state == .running ? "stop" : "start") {
                    startAndStop()
                }
                .buttonStyle(.plain)
                .disabled(vm.remainingTime == 0)
                .hoverBackground()
                
                Spacer()
                
                Text(formatTime(vm.remainingTime))
                    .monospacedDigit()
                    .font(.largeTitle.monospacedDigit())
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    // MARK: - Actions
    private func label(for state: TimerViewModel.State) -> String {
        switch state {
        case .idle: return "Idle"
        case .running: return "Running"
        case .paused: return "Paused"
        case .finished: return "Finished"
        }
    }
    private func setAndToggle(_ minutes: Int) {
        vm.setDuration(minutes: minutes)
        if vm.state == .running {
            vm.pause()
        } else {
            vm.start()
        }
    }
    private func startAndStop() {
        if vm.state == .running {
            vm.pause()
        } else {
            vm.start()
        }
    }
}
// MARK: - Helpers
private struct PopoverMenu: View {
    @Binding var showPopover: Bool
    @Binding var showFloatingDisplay: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Button("Settings…") {

            }
            .buttonStyle(.plain)
            .hoverBackground()

            Button("Show Floating Display") {
                
            }
            .buttonStyle(.plain)
            .hoverBackground()

            Divider()

            Button("About Mubushi") {
                NSApp.orderFrontStandardAboutPanel(nil)
                NSApp.activate(ignoringOtherApps: true)
            }
            .buttonStyle(.plain)
            .hoverBackground()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .hoverBackground()
        }
        .padding(0)
    }
}

#Preview { ContentView() }

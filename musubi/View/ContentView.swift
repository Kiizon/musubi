//
//  ContentView.swift
//  musubi
//
//  Created by Kish Dizon on 2025-10-07.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: TimerViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @State private var sliderMinutes: Int = 25

    @State private var showPopover = false
    @State private var showSettings = false

    var body: some View {
        VStack(alignment: .leading) {
            RulerSlider(value: $sliderMinutes, range: 0...120, accentColor: settings.accentColor)
                .onChange(of: sliderMinutes) { newValue in
                    vm.setDuration(minutes: newValue)
                }

            HStack {
                Button("\(settings.preset1)m") { setAndToggle(settings.preset1) }
                    .buttonStyle(.plain)
                    .hoverBackground()

                Button("\(settings.preset2)m") { setAndToggle(settings.preset2) }
                    .buttonStyle(.plain)
                    .hoverBackground()

                Button("\(settings.preset3)m") { setAndToggle(settings.preset3) }
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
                .popover(isPresented: $showPopover, attachmentAnchor: .rect(.bounds), arrowEdge: .top) {
                    PopoverMenu(
                        showPopover: $showPopover,
                        showSettings: $showSettings
                    )
                    .environmentObject(settings)
                    .frame(width: 150)
                    .padding(8)
                }
            }

            HStack {
                Button("\(settings.preset4)m") { setAndToggle(settings.preset4) }
                    .buttonStyle(.plain)
                    .hoverBackground()

                Button("\(settings.preset5)m") { setAndToggle(settings.preset5) }
                    .buttonStyle(.plain)
                    .hoverBackground()

                Button("\(settings.preset6)m") { setAndToggle(settings.preset6) }
                    .buttonStyle(.plain)
                    .hoverBackground()

                Spacer()
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
                    .foregroundColor(settings.highContrastTimer ? settings.accentColor : .gray)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .popover(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(settings)
        }
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
        sliderMinutes = minutes
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
    @EnvironmentObject var settings: SettingsViewModel
    @Binding var showPopover: Bool
    @Binding var showSettings: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Button("Settings…") {
                showPopover = false
                showSettings = true
            }
            .buttonStyle(.plain)
            .hoverBackground()

            Button(settings.showFloatingTimer ? "Hide Floating Timer" : "Show Floating Timer") {
                settings.showFloatingTimer.toggle()
                showPopover = false
            }
            .buttonStyle(.plain)
            .hoverBackground()

            Divider()

            Button("About musubi") {
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

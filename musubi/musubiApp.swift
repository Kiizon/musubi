//
//  musubiApp.swift
//  musubi
//
//  Created by Kish Dizon on 2025-10-07.
//

import SwiftUI
import Combine

@main
struct musubiApp: App {
    @StateObject private var timerVM = TimerViewModel(minutes: 25)
    @StateObject private var tasksVM = TasksViewModel()
    @StateObject private var settingsVM = SettingsViewModel()
    @StateObject private var floatingWindowController = FloatingWindowController()

    var body: some Scene {
        MenuBarExtra {
            VStack {
                ContentView()
                    .environmentObject(timerVM)
                    .environmentObject(settingsVM)
                    .frame(height: 140)

                Divider()

                TasksView()
                    .environmentObject(tasksVM)
            }
            .onAppear {
                floatingWindowController.setup(timerVM: timerVM, settingsVM: settingsVM)
            }
        } label: {
            pillTemplateImage(formatTimeForMenubar(timerVM.remainingTime), highContrast: settingsVM.highContrastTimer, accentColor: settingsVM.accentColor)
        }
        .menuBarExtraStyle(.window)
    }
}

// MARK: - Floating Window Controller

class FloatingWindowController: ObservableObject {
    private var floatingWindow: FloatingTimerWindow?
    private var cancellables = Set<AnyCancellable>()
    private weak var settingsVM: SettingsViewModel?

    func setup(timerVM: TimerViewModel, settingsVM: SettingsViewModel) {
        guard self.settingsVM == nil else { return }
        self.settingsVM = settingsVM

        settingsVM.$showFloatingTimer
            .receive(on: DispatchQueue.main)
            .sink { [weak self] show in
                self?.updateFloatingWindow(show: show, timerVM: timerVM)
            }
            .store(in: &cancellables)
    }

    private func updateFloatingWindow(show: Bool, timerVM: TimerViewModel) {
        if show {
            if floatingWindow == nil, let settingsVM = settingsVM {
                floatingWindow = FloatingTimerWindow(timerVM: timerVM, settingsVM: settingsVM) { [weak self] in
                    self?.settingsVM?.showFloatingTimer = false
                }
            }
            floatingWindow?.show()
        } else {
            let windowToClose = floatingWindow
            floatingWindow = nil
            DispatchQueue.main.async {
                windowToClose?.close()
            }
        }
    }
}
func pillTemplateImage(_ text: String, highContrast: Bool, accentColor: Color) -> Image {
    let pill = Text(text)
        .font(.system(size: 10, weight: .semibold))
        .foregroundColor(highContrast ? accentColor : .gray)
        .frame(width: 45, height: 15)
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
    ns.isTemplate = !highContrast
    return Image(nsImage: ns).renderingMode(highContrast ? .original : .template)
}

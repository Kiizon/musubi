//
//  SettingsViewModel.swift
//  musubi
//
//  Created by Kish Dizon on 2025-11-19.
//
import Foundation
import SwiftUI
import Combine
import ServiceManagement

final class SettingsViewModel: ObservableObject {
    @Published var preset1: Int {
        didSet { UserDefaults.standard.set(preset1, forKey: "preset1") }
    }
    @Published var preset2: Int {
        didSet { UserDefaults.standard.set(preset2, forKey: "preset2") }
    }
    @Published var preset3: Int {
        didSet { UserDefaults.standard.set(preset3, forKey: "preset3") }
    }
    @Published var alarmVolume: Double {
        didSet { UserDefaults.standard.set(alarmVolume, forKey: "alarmVolume") }
    }
    @Published var highContrastTimer: Bool {
        didSet { UserDefaults.standard.set(highContrastTimer, forKey: "highContrastTimer") }
    }
    @Published var showFloatingTimer: Bool {
        didSet { UserDefaults.standard.set(showFloatingTimer, forKey: "showFloatingTimer") }
    }

    var launchAtLogin: Bool {
        get { SMAppService.mainApp.status == .enabled }
        set {
            objectWillChange.send()
            do {
                if newValue {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Failed to \(newValue ? "enable" : "disable") launch at login: \(error)")
            }
        }
    }

    init() {
        let defaults = UserDefaults.standard
        self.preset1 = defaults.object(forKey: "preset1") as? Int ?? 5
        self.preset2 = defaults.object(forKey: "preset2") as? Int ?? 10
        self.preset3 = defaults.object(forKey: "preset3") as? Int ?? 25
        self.alarmVolume = defaults.object(forKey: "alarmVolume") as? Double ?? 0.5
        self.highContrastTimer = defaults.bool(forKey: "highContrastTimer")
        self.showFloatingTimer = defaults.bool(forKey: "showFloatingTimer")
    }
}

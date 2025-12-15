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
    @Published var preset4: Int {
        didSet { UserDefaults.standard.set(preset4, forKey: "preset4") }
    }
    @Published var preset5: Int {
        didSet { UserDefaults.standard.set(preset5, forKey: "preset5") }
    }
    @Published var preset6: Int {
        didSet { UserDefaults.standard.set(preset6, forKey: "preset6") }
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
    @Published var accentColor: Color {
        didSet { UserDefaults.standard.set(accentColor.hexString, forKey: "accentColor") }
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
        self.preset4 = defaults.object(forKey: "preset4") as? Int ?? 45
        self.preset5 = defaults.object(forKey: "preset5") as? Int ?? 60
        self.preset6 = defaults.object(forKey: "preset6") as? Int ?? 90
        self.alarmVolume = defaults.object(forKey: "alarmVolume") as? Double ?? 0.5
        self.highContrastTimer = defaults.bool(forKey: "highContrastTimer")
        self.showFloatingTimer = defaults.bool(forKey: "showFloatingTimer")
        if let hex = defaults.string(forKey: "accentColor") {
            self.accentColor = Color(hex: hex) ?? .white
        } else {
            self.accentColor = .white
        }
    }
}

// MARK: - Color Hex Extension

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }

    var hexString: String {
        guard let components = NSColor(self).usingColorSpace(.deviceRGB) else { return "FFFFFF" }
        let r = Int(components.redComponent * 255)
        let g = Int(components.greenComponent * 255)
        let b = Int(components.blueComponent * 255)
        return String(format: "%02X%02X%02X", r, g, b)
    }
}

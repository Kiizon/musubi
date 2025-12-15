//
//  SettingsView.swift
//  musubi
//
//  Created by Kish Dizon on 2025-11-19.
//

import SwiftUI
import AppKit

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.headline)

            // Timer Presets
            VStack(alignment: .leading, spacing: 8) {
                Text("Timer Presets")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack(spacing: 8) {
                    PresetStepper(value: $settings.preset1)
                        .frame(maxWidth: .infinity)
                    PresetStepper(value: $settings.preset2)
                        .frame(maxWidth: .infinity)
                    PresetStepper(value: $settings.preset3)
                        .frame(maxWidth: .infinity)
                }
                HStack(spacing: 8) {
                    PresetStepper(value: $settings.preset4)
                        .frame(maxWidth: .infinity)
                    PresetStepper(value: $settings.preset5)
                        .frame(maxWidth: .infinity)
                    PresetStepper(value: $settings.preset6)
                        .frame(maxWidth: .infinity)
                }
                
            }

            Divider()

            // Alarm Volume
            VStack(alignment: .leading, spacing: 8) {
                Text("Alarm Volume")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack {
                    Image(systemName: "speaker.fill")
                        .foregroundColor(.secondary)
                    Slider(value: $settings.alarmVolume, in: 0...1)
                        .tint(.gray.opacity(0.5))
                        .onChange(of: settings.alarmVolume) { _, newValue in
                            playPreviewSound(volume: newValue)
                        }
                    Image(systemName: "speaker.wave.3.fill")
                        .foregroundColor(.secondary)
                }
            }

            Divider()

            // High Contrast Timer
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("High Contrast Timer")
                    Text("Boost visibility of the timer display")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                PlainCheckbox(isOn: $settings.highContrastTimer, accentColor: settings.accentColor)
            }

            Divider()

            // Launch at Login
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Launch at Login")
                    Text("Open musubi when you log in")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                PlainCheckbox(isOn: Binding(
                    get: { settings.launchAtLogin },
                    set: { settings.launchAtLogin = $0 }
                ), accentColor: settings.accentColor)
            }

            Divider()

            // Accent Color
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Accent Color")
                    Text("Customize the app color")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                ColorPicker("", selection: $settings.accentColor, supportsOpacity: false)
                    .labelsHidden()
                    .frame(width: 24, height: 24)
            }
        }
        .padding()
        .frame(width: 280)
        .contentShape(Rectangle())
        .onTapGesture {
            NSApp.keyWindow?.makeFirstResponder(nil)
        }
        .onAppear {
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    private static var previewSound: NSSound?

    private func playPreviewSound(volume: Double) {
        Self.previewSound?.stop()
        if let sound = NSSound(named: "Glass")?.copy() as? NSSound {
            sound.volume = Float(volume)
            sound.play()
            Self.previewSound = sound
        }
    }
}

private struct PlainCheckbox: View {
    @Binding var isOn: Bool
    var accentColor: Color = .primary

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isOn ? accentColor : Color.primary.opacity(0.3), lineWidth: 1.5)
                if isOn {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(accentColor)
                }
            }
            .frame(width: 16, height: 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

private struct PresetStepper: View {
    @Binding var value: Int

    private static let presetOptions = [1, 2, 3, 5, 10, 15, 20, 25, 30, 45, 60, 90, 120]

    var body: some View {
        Picker("", selection: $value) {
            ForEach(Self.presetOptions, id: \.self) { minutes in
                Text("\(minutes)").tag(minutes)
            }
        }
        .labelsHidden()
        .pickerStyle(.menu)
        .tint(Color.gray.opacity(0.6))
        .frame(width: 60)
    }
}


#Preview {
    SettingsView()
        .environmentObject(SettingsViewModel())
}

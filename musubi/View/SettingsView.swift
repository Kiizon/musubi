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
                PlainCheckbox(isOn: $settings.highContrastTimer)
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
                ))
            }
        }
        .padding()
        .frame(width: 280)
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

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            Image(systemName: isOn ? "checkmark.square.fill" : "square")
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .opacity(0.5)
        }
        .buttonStyle(.plain)
    }
}

private struct PresetStepper: View {
    @Binding var value: Int
    @State private var textValue: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 4) {
            TextField("", text: $textValue)
                .textFieldStyle(.plain)
                .monospacedDigit()
                .frame(width: 32)
                .multilineTextAlignment(.trailing)
                .focused($isFocused)
                .onAppear { textValue = "\(value)" }
                .onChange(of: value) { _, newValue in
                    textValue = "\(newValue)"
                }
                .onSubmit {
                    commitValue()
                    isFocused = false
                }
                .onChange(of: isFocused) { _, focused in
                    if !focused { commitValue() }
                }

            VStack(spacing: 0) {
                Button {
                    isFocused = true
                    value = min(120, value + 1)
                } label: {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 8, weight: .medium))
                        .frame(width: 16, height: 12)
                }
                .buttonStyle(.plain)
                .opacity(0.5)

                Button {
                    isFocused = true
                    value = max(1, value - 1)
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 8, weight: .medium))
                        .frame(width: 16, height: 12)
                }
                .buttonStyle(.plain)
                .opacity(0.5)
            }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(isFocused ? Color.gray.opacity(0.2) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .focusEffectDisabled()
    }

    private func commitValue() {
        if let parsed = Int(textValue), parsed >= 1, parsed <= 120 {
            value = parsed
        }
        textValue = "\(value)"
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsViewModel())
}

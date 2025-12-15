//
//  FloatingTimerView.swift
//  musubi
//
//  Created by Kish Dizon on 2025-12-14.
//

import SwiftUI
import AppKit

// MARK: - Floating Timer View

struct FloatingTimerView: View {
    @ObservedObject var timerVM: TimerViewModel
    @ObservedObject var settingsVM: SettingsViewModel
    var onClose: () -> Void

    @State private var isHovering = false

    var body: some View {
        Text(formatTime(timerVM.remainingTime))
            .font(.system(size: 24, weight: .medium, design: .monospaced))
            .foregroundColor(settingsVM.accentColor)
            .frame(minWidth: 120)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .overlay(alignment: .topTrailing) {
                if isHovering {
                    Button {
                        onClose()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 14, height: 14)
                            .background(Circle().fill(Color.white.opacity(0.15)))
                    }
                    .buttonStyle(.plain)
                    .padding(6)
                }
            }
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.7))
            )
            .fixedSize()
            .onHover { hovering in
                isHovering = hovering
            }
    }
}

// MARK: - Floating Window Manager

class FloatingTimerWindow {
    private var window: DraggableWindow?
    private var timerVM: TimerViewModel
    private var settingsVM: SettingsViewModel
    private var onClose: () -> Void

    init(timerVM: TimerViewModel, settingsVM: SettingsViewModel, onClose: @escaping () -> Void) {
        self.timerVM = timerVM
        self.settingsVM = settingsVM
        self.onClose = onClose
    }

    func show() {
        guard window == nil else {
            window?.orderFront(nil)
            return
        }

        let contentView = FloatingTimerView(timerVM: timerVM, settingsVM: settingsVM, onClose: { [weak self] in
            // Defer to next run loop to avoid deallocating window while view is executing
            DispatchQueue.main.async {
                self?.onClose()
            }
        })

        let hostingView = NSHostingView(rootView: contentView)
        let fittingSize = hostingView.fittingSize
        hostingView.frame = CGRect(origin: .zero, size: fittingSize)

        let window = DraggableWindow(
            contentRect: hostingView.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        window.contentView = hostingView
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.hasShadow = true

        // Position in top-right corner of main screen
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let x = screenFrame.maxX - hostingView.frame.width - 20
            let y = screenFrame.maxY - hostingView.frame.height - 20
            window.setFrameOrigin(NSPoint(x: x, y: y))
        }

        window.orderFront(nil)
        self.window = window
    }

    func close() {
        guard let window = window else { return }
        window.contentView = nil
        window.orderOut(nil)
        window.close()
        self.window = nil
    }

    var isVisible: Bool {
        window != nil
    }
}

// MARK: - Draggable Window

private class DraggableWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }

    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        isMovableByWindowBackground = true
        isReleasedWhenClosed = false
    }
}

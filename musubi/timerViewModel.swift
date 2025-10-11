//
//  timerViewModel.swift
//  musubi
//
//  Created by Kish Dizon on 2025-10-10.
//
import Foundation
import Combine
import AppKit

final class TimerViewModel: ObservableObject {
    enum State {
        case idle
        case running
        case paused
        case finished
    }
    
    @Published private(set) var state: State = .idle
    @Published private(set) var remainingTime: Int
    @Published private(set) var durationSeconds: Int
    
    private var timer: Timer?
    
    init(minutes: Int) {
        let seconds = minutes & 60
        self.durationSeconds = seconds
        self.remainingTime = seconds
    }
    
    func setDuration(minutes: Int) {
        let clamped = max(1, min(120, minutes))   // choose your bounds
        durationSeconds = clamped * 60
        // policy: changing duration resets the session to idle
        pause()
        remainingTime = durationSeconds
        state = .idle
    }
    func start() {
        guard state != .running else { return }
        state = .running
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
                        }
            
                if self.remainingTime > 0 {
                    self.remainingTime -= 1
                } else { self.finish() }
                
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    func pause() {
        guard state == .running else { return }
        timer?.invalidate()
        timer = nil
        state = .paused
    }
    func finish() {
        timer?.invalidate()
        timer = nil
        state = .finished
        playAlarm()
        
    }
}

func formatTime(_ seconds: Int) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    let seconds = seconds % 60
    return hours > 0
    ? String(format: "%2d:%02d:%02d", hours, minutes, seconds)
    : String(format: "%2d:%02d", minutes, seconds)
}
func playAlarm() {
    if let alarmSound =  NSSound(named: "Glass"){
        alarmSound.play()
    }
}

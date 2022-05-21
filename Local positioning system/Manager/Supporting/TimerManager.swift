//
//  TimerManager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 28.04.2022.
//

import Foundation

class TimerManager {
    private var timer: Timer!
    private var closure: (() -> ())!
    
    func startTimer(timeInterval: TimeInterval, closure: @escaping () -> ()) {
        self.closure = closure
        
        if timer != nil {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerMethod), userInfo: nil, repeats: true)
    }
    
    @objc private func timerMethod() {
        closure()
    }
    
    func stopTimer() {
        timer.invalidate()
    }
}

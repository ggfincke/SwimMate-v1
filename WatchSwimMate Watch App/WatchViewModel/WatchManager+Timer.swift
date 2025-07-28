// WatchManager+Timer.swift

// Timer Management Extension

import Foundation

// MARK: - Timer Management

extension WatchManager
{
    // start elapsed time timer
    func startElapsedTimer()
    {
        stopElapsedTimer()
        workoutStartDate = Date()
        elapsedTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true)
        {
            [weak self] _ in
            self?.updateElapsedTime()
        }
    }

    // stop elapsed time timer
    func stopElapsedTimer()
    {
        elapsedTimer?.invalidate()
        elapsedTimer = nil
    }

    // update elapsed time based on workout start date
    private func updateElapsedTime()
    {
        guard let startDate = workoutStartDate
        else
        {
            return
        }
        DispatchQueue.main.async
        {
            self.elapsedTime = Date().timeIntervalSince(startDate)
        }
    }
}

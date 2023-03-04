//
//  MotionManager.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/04.
//

import CoreMotion
import Combine

struct MotionManager {
  private let motionManager = CMMotionActivityManager()
  private let activeMotionSubject = PassthroughSubject<Bool, Never>()
  
  init() {
    observeMotion()
  }
  
  func fetchActiveMotion() -> AnyPublisher<Bool, Never> {
    activeMotionSubject.eraseToAnyPublisher()
  }
  
  private func observeMotion() {
    guard CMMotionActivityManager.isActivityAvailable() else { return }
    motionManager.startActivityUpdates(to: .main) { activity in
      guard let activity = activity else { return }
      
      if activity.stationary {
        self.activeMotionSubject.send(false)
      }
      
      if activity.walking || activity.running {
        self.activeMotionSubject.send(true)
      }
    }
  }
}

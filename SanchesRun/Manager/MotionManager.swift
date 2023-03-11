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
  private let permissionDeniedSubject = PassthroughSubject<Bool, Never>()
  
  init() {
    observeMotion()
    observePermissionDenied()
  }
  
  func observeActiveMotion() -> AnyPublisher<Bool, Never> {
    activeMotionSubject.eraseToAnyPublisher()
  }
  
  func observeMotionPermissionDenied() -> AnyPublisher<Bool, Never> {
    permissionDeniedSubject.eraseToAnyPublisher()
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
  
  private func observePermissionDenied() {
    let today = Date()
    motionManager.queryActivityStarting(
      from: today, to: today, to: .main) { _, _ in
        switch CMMotionActivityManager.authorizationStatus() {
        case .denied:
          permissionDeniedSubject.send(true)
        case .authorized:
          permissionDeniedSubject.send(false)
        default:
          break
        }
      }
  }
}

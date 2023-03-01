//
//  TimerManager.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/01.
//

import Foundation

final class TimerManager {
  private var startDate = Date()
  private var isActive = false
  private var difference: TimeInterval = 0
  private var pauseTimeInterval: TimeInterval = 0
  
  func start() {
    if pauseTimeInterval == 0 {
      self.startDate = Date()
    } else {
      self.startDate = Date(timeIntervalSinceNow: -pauseTimeInterval)
    }
    self.isActive = true
  }
  
  var reset: TimeInterval {
    self.isActive = false
    self.pauseTimeInterval = 0
    return 0
  }
  
  var update: TimeInterval {
    self.difference = Date().timeIntervalSince(startDate)
    return difference
  }
  
  func pause() {
    self.isActive = false
    self.pauseTimeInterval = difference
  }
}


//
//  MainViewModel.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/02/27.
//

import Foundation
import Combine

final class RunViewModel: ObservableObject {
  private let locationManager = LocationManager()
  private let timerManager = TimerManager()
  private var cancellable = Set<AnyCancellable>()
  
  @Published private(set) var time: TimeInterval = 0
  @Published private(set) var timerState: TimerState = .stop
  
  init() {
    fetchLocation()
  }
  
  private func fetchLocation() {
    locationManager.fetchCurrentLocation()
      .setFailureType(to: Error.self)
      .sink { [weak self] completion in
        self?.onReceiveCompletion("fetchLocation finished", completion)
      } receiveValue: { result in
        print("location: \(String(describing: result))")
      }
      .store(in: &cancellable)
  }
  
  func timerReset() {
    timerState = .stop
    self.time = timerManager.reset
    
  }
  
  func timerStart() {
    timerManager.start()
    timerState = .active
  }
  
  func timerUpdate() {
    guard timerState == .active else { return }
    self.time = timerManager.update
  }
  
  func timerPause() {
    timerState = .pause
    timerManager.pause()
  }
}

//
//  MainViewModel.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/02/27.
//

import Foundation
import Combine
import NMapsMap

final class RunViewModel: ObservableObject {
  private let locationManager = LocationManager()
  private let timerManager = TimerManager()
  private var cancellable = Set<AnyCancellable>()
  
  @Published private(set) var time: TimeInterval = 0
  @Published private(set) var timerState: TimerState = .stop
  @Published private(set) var runPaths: [NMGLatLng] = []
  @Published private(set) var firstUserLocation: NMGLatLng?
  
  init() {
    setFirstUserLocation()
    fetchRunPaths()
  }
  
  private func setFirstUserLocation() {
    locationManager.fetchCurrentLocation()
      .compactMap { $0 }
      .map {
        NMGLatLng(
          lat: $0.coordinate.latitude,
          lng: $0.coordinate.longitude
        )
      }
      .first()
      .assign(to: &$firstUserLocation)
  }
  
  private func fetchRunPaths() {
    locationManager.fetchCurrentLocation()
      .filter { _ in self.timerState == .active }
      .compactMap{ $0 }
      .removeDuplicates { preValue, currentValue in
        let difference = preValue.distance(from: currentValue)
        let allowableDistance: Double = 20
        return allowableDistance > difference
      }
      .map {
        NMGLatLng(
          lat: $0.coordinate.latitude,
          lng: $0.coordinate.longitude
        )
      }
      .sink { result in
        self.runPaths.append(result)
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

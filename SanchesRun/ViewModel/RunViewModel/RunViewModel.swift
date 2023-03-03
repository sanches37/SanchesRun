//
//  MainViewModel.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/02/27.
//

import Foundation
import Combine
import NMapsMap
import SwiftUI

final class RunViewModel: ObservableObject {
  private let locationManager = LocationManager()
  private let timerManager = TimerManager()
  private lazy var mapViewDelegate = RunViewDelegate(viewModel: self)
  var cancellable = Set<AnyCancellable>()
  
  @Published private(set) var time: TimeInterval = 0
  @Published private(set) var timerState: TimerState = .stop
  @Published private(set) var runPaths: [[NMGLatLng]] = []
  @Published private(set) var userLocation: NMGLatLng?
  
  init() {
    fetchFirstLocation()
    fetchRunPaths()
    updateRunPathsByTimerState()
  }
  
  private func fetchLocationOnce() -> AnyPublisher<NMGLatLng, Never> {
    locationManager.fetchCurrentLocation()
      .compactMap { $0 }
      .first()
      .flatMap {
        Just(
          NMGLatLng(lat: $0.coordinate.latitude, lng: $0.coordinate.longitude)
        )
      }
      .eraseToAnyPublisher()
  }
  
  private func fetchFirstLocation() {
    fetchLocationOnce()
      .sink { result in
        self.userLocation = result
      }
      .store(in: &cancellable)
  }
  
  private func fetchRunPaths() {
    locationManager.fetchCurrentLocation()
      .filter { [weak self] _ in
        self?.timerState == .active
      }
      .compactMap{ $0 }
      .removeDuplicates { preValue, currentValue in
        let difference = preValue.distance(from: currentValue)
        let allowableDistance: Double = 15
        return allowableDistance > difference
      }
      .map {
        NMGLatLng(
          lat: $0.coordinate.latitude,
          lng: $0.coordinate.longitude
        )
      }
      .sink { [weak self] result in
        self?.updateRunPaths(location: result)
      }
      .store(in: &cancellable)
  }
  
  private func updateRunPaths(location: NMGLatLng) {
    guard !runPaths.isEmpty else { return }
    runPaths[runPaths.count - 1].append(location)
  }
  
  private func updateRunPathsByTimerState() {
    $timerState
      .filter { $0 != .stop }
      .flatMap { _ in
        self.fetchLocationOnce()
      }
      .sink { result in
        self.updateRunPaths(location: result)
      }
      .store(in: &cancellable)
  }
  
  func timerReset() {
    timerState = .stop
    self.time = timerManager.reset
  }
  
  func timerStart() {
    runPaths.append([NMGLatLng]())
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

extension RunViewModel: MapAvailable {
  func setUp(mapView: NMFMapView) {
    mapViewDelegate.defaultSetting(mapView: mapView)
    mapViewDelegate.firstLocation(mapView: mapView)
    mapViewDelegate.focusRunLocation(mapView: mapView)
    mapViewDelegate.updatePath(mapView: mapView)
  }
}
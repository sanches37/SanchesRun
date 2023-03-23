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
  private let motionManager = MotionManager()
  private let liveActivityManager = LiveActivityManager()
  private var cancellable = Set<AnyCancellable>()
  
  @Published private var userLocation: Location?
  @Published private(set) var time: TimeInterval = 0
  @Published private(set) var timerState: TimerState = .stop
  @Published private(set) var runPaths: [[Location]] = []
  @Published private(set) var focusLocation: Location?
  @Published private(set) var totalDistance: Double = 0
  @Published private(set) var oneKilometerPace: TimeInterval = 0
  @Published var islocationPermissionDenied = false
  @Published var isLocationAndMotionPermissionDenied = false
  private var startDate: Date?
  private(set) var permissionDenied: PermissionDenied?
  
  init() {
    fetchLocation()
    fetchFirstLocation()
    fetchRunPathsByActive()
    fetchRunPathsByPause()
    fetchAveragePace()
    checkPermissionDenied()
    
    if #available(iOS 16.1, *) {
      updateLiveActivityByAveragePace()
    }
  }
  
  deinit {
    print("RunViewModel deinit")
  }
  
  private func fetchLocation() {
    locationManager.observeLocation()
      .map{
        guard let result = $0 else { return nil }
        return Location(
          latitude: result.coordinate.latitude,
          longitude: result.coordinate.longitude)
      }
      .sink { [weak self] result in
        self?.userLocation = result
      }
      .store(in: &cancellable)
  }
  
  private func fetchFirstLocation() {
    $userLocation
      .compactMap{ $0 }
      .first()
      .sink { result in
        self.focusLocation = result
      }
      .store(in: &cancellable)
  }
  
  func fetchLocationByButton() {
    if userLocation == nil {
      islocationPermissionDenied = true
    } else {
      fetchFirstLocation()
    }
  }
  
  private func fetchRunPathsByActive() {
    Publishers.CombineLatest(
      $userLocation,
      motionManager.observeActiveMotion()
    )
    .filter { [weak self] _, isActiveMotion in
      self?.timerState == .active && isActiveMotion
    }
    .compactMap { location, _ in location }
    .removeDuplicates { preValue, currentValue in
      let difference = preValue.distance(from: currentValue)
      let allowableDistance: Double = 10
      return allowableDistance > difference
    }
    .sink { [weak self] result in
      self?.updateRunPaths(location: result)
    }
    .store(in: &cancellable)
  }
  
  private func fetchRunPathsByPause() {
    $timerState
      .filter { $0 == .pause }
      .flatMap { [weak self] _ in
        self?.$userLocation.first().eraseToAnyPublisher() ?? Just(nil).eraseToAnyPublisher()
      }
      .compactMap { $0 }
      .sink { [weak self] result in
        self?.updateRunPaths(location: result)
      }
      .store(in: &cancellable)
  }
  
  private func updateRunPaths(location: Location) {
    guard !runPaths.isEmpty else { return }
    runPaths[runPaths.count - 1].append(location)
    addRunningDistance = location
  }
  
  private var addRunningDistance: Location? {
    didSet {
      if let oldValue = oldValue,
         let addRunningDistance = addRunningDistance {
        totalDistance += oldValue.distance(from: addRunningDistance)
      }
    }
  }
  
  private func fetchAveragePace() {
    $totalDistance
      .dropFirst()
      .map { [weak self] distance in
        guard let self = self,
              distance != 0 else { return 0 }
        let meterPerSecond = distance / self.time
        return 1000 / meterPerSecond
      }
      .sink { [weak self] result in
        self?.oneKilometerPace = result
      }
      .store(in: &cancellable)
  }
  
  func timerEnd() {
    timerState = .stop
    saveRun()
    reset()
  }
  
  private func reset() {
    self.runPaths.removeAll()
    self.startDate = nil
    self.time = timerManager.reset
    self.oneKilometerPace = 0
    self.totalDistance = 0
  }
  
  func timerStart() {
    isLocationAndMotionPermissionDenied =
    (permissionDenied == nil ? false : true)
    
    if isLocationAndMotionPermissionDenied == false {
      activeStart()
    }
  }
  
  private func activeStart() {
    self.addRunningDistance = nil
    self.runPaths.append([Location]())
    self.timerManager.start()
    self.saveStartDate()
    self.timerState = .active
    
    if #available(iOS 16.1, *) {
      addLiveActivity()
    }
  }
  
  func timerUpdate() {
    guard timerState == .active else { return }
    self.time = timerManager.update
  }
  
  func timerPause() {
    timerState = .pause
    timerManager.pause()
    
    if #available(iOS 16.1, *) {
      stopLiveActivity()
    }
  }
  
  private func saveRun() {
    let run = Run(context: PersistenceController.shared.viewContext)
    run.id = UUID().uuidString
    run.startDate = self.startDate
    run.runPaths = self.runPaths
    run.activeTime = self.time
    run.totalDistance = self.totalDistance
    run.averagePace = self.oneKilometerPace
    PersistenceController.shared.save()
  }
  
  private func saveStartDate() {
    if startDate == nil {
      startDate = Date()
    }
  }
  
  private func checkPermissionDenied() {
    Publishers.CombineLatest(
      $userLocation
        .map { $0 == nil },
      motionManager.observeMotionPermissionDenied()
    )
    .map { locationDenied, motionDenied in
      if locationDenied && motionDenied {
        return .locationAndMotion
      } else if locationDenied {
        return .location
      } else if motionDenied {
        return .motion
      }
      return nil
    }
    .sink { [weak self] result in
      self?.permissionDenied = result
    }
    .store(in: &cancellable)
  }
}

@available(iOS 16.1, *)
extension RunViewModel {
  private var initAttributes: RunAttributes {
    return RunAttributes(startDate: timerManager.startDate)
  }
  
  private var initContentState: RunAttributes.ContentState {
    return RunAttributes.ContentState(
      totalDistance: self.totalDistance.withMeter,
      oneKilometerPace: self.oneKilometerPace.positionalTime
    )
  }
  
  private func addLiveActivity() {
    liveActivityManager.add(initAttributes, initContentState)
  }
  
  private func stopLiveActivity() {
    liveActivityManager.stop(initAttributes)
  }
  
  private func updateLiveActivity() {
    liveActivityManager.update(initAttributes, initContentState)
  }
  
  private func updateLiveActivityByAveragePace() {
    $oneKilometerPace
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.updateLiveActivity()
      }
      .store(in: &cancellable)
  }
}

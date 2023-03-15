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
    fetchRunPaths()
    fetchRunPathsByTimerState()
    fetchAveragePace()
    checkPermissionDenied()
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
  
  private func fetchRunPaths() {
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
      let allowableDistance: Double = 15
      return allowableDistance > difference
    }
    .sink { [weak self] result in
      self?.updateRunPaths(location: result)
    }
    .store(in: &cancellable)
  }
  
  private func fetchRunPathsByTimerState() {
    $timerState
      .filter { $0 != .stop }
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

import ActivityKit

@available(iOS 16.1, *)
extension RunViewModel {
  private func addLiveActivity() {
    let runAttributes = RunAttributes()
    let initalContentState = RunAttributes.ContentState(
      time: self.time,
      totalDistance: self.totalDistance,
      oneKilometerPace: self.oneKilometerPace
    )
    
    do {
      let activity = try Activity<RunAttributes>.request(
        attributes: runAttributes,
        contentState: initalContentState,
        pushType: nil
      )
      print("success id: \(activity.id)")
    } catch {
      debugPrint(error.localizedDescription)
    }
  }
}

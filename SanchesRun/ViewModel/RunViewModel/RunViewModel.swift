//
//  MainViewModel.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/02/27.
//

import Combine
import NMapsMap

final class RunViewModel: ObservableObject {
  private let locationManager = LocationManager()
  private let timerManager = TimerManager()
  private let motionManager = MotionManager()
  private lazy var mapViewDelegate = MapOfRunViewDelegate(viewModel: self)
  var cancellable = Set<AnyCancellable>()
  
  @Published private(set) var time: TimeInterval = 0
  @Published private(set) var timerState: TimerState = .stop
  @Published private(set) var runPaths: [[NMGLatLng]] = []
  @Published private(set) var userLocation: NMGLatLng?
  @Published private(set) var totalDistance: Double = 0
  @Published private(set) var oneKilometerPace: TimeInterval = 0
  
  init() {
    fetchFirstLocation()
    fetchRunPaths()
    fetchRunPathsByTimerState()
    fetchAveragePace()
  }
  
  private func fetchLocationOnce() -> AnyPublisher<NMGLatLng, Never> {
    locationManager.observeLocation()
      .compactMap { $0 }
      .first()
      .flatMap {
        return Just(
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
    Publishers.CombineLatest(
      locationManager.observeLocation(),
      motionManager.observeActiveMotion()
    )
    .filter { self.timerState == .active && $1 }
    .compactMap { location, _ in location }
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
  
  private func fetchRunPathsByTimerState() {
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
  
  private func updateRunPaths(location: NMGLatLng) {
    guard !runPaths.isEmpty else { return }
    runPaths[runPaths.count - 1].append(location)
    addRunningDistance = location
  }
  
  private var addRunningDistance: NMGLatLng? {
    didSet {
      if let oldValue = oldValue,
         let addRunningDistance = addRunningDistance {
        totalDistance += oldValue.distance(to: addRunningDistance)
      }
    }
  }
  
  private func fetchAveragePace() {
    $totalDistance
      .dropFirst()
      .map { [weak self] distance in
        guard let self = self,
              distance != 0 else { return 0.0 }
        let meterPerSecond = distance / self.time
        return 1000 / meterPerSecond
      }
      .sink { [weak self] result in
        self?.oneKilometerPace = result
      }
      .store(in: &cancellable)
  }
  
  func timerReset() {
    timerState = .stop
    saveRun()
  }
  
  func timerStart() {
    addRunningDistance = nil
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
  
  private func saveRun() {
    let run = Run(context: PersistenceController.shared.viewContext)
    run.runPaths = self.runPaths
    run.activeTime = self.time
    run.totalDistance = self.totalDistance
    run.averagePace = self.oneKilometerPace
    PersistenceController.shared.save()
  }
}

extension RunViewModel: MapAvailable {
  func setUp(mapView: NMFMapView) {
    mapViewDelegate.defaultSetting(mapView: mapView)
    mapViewDelegate.focusFirstLocation(mapView: mapView)
    mapViewDelegate.focusPathLocation(mapView: mapView)
    mapViewDelegate.updatePath(mapView: mapView)
  }
}

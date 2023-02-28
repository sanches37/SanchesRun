//
//  LocationManager.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/02/27.
//

import CoreLocation
import Combine

final class LocationManager: NSObject {
  private let locationManager = CLLocationManager()
  private let locationSubject = PassthroughSubject<CLLocation?, Never>()
  
  override init() {
    super.init()
    defaultSetting()
  }
  
  private func defaultSetting() {
    locationManager.delegate = self
    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.showsBackgroundLocationIndicator = true
  }
  
  func fetchCurrentLocation() -> AnyPublisher<CLLocation?, Never> {
    locationSubject
      .eraseToAnyPublisher()
  }
}

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    locationSubject.send(location)
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    decidedAuthorization(status: manager.authorizationStatus)
  }
  
  private func decidedAuthorization(status: CLAuthorizationStatus) {
    switch status {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .denied:
      locationSubject.send(nil)
    case .authorizedAlways, .authorizedWhenInUse:
      locationManager.startUpdatingLocation()
    default:
      break
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    debugPrint(error.localizedDescription)
  }
}

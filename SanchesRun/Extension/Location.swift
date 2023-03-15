//
//  Location.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/15.
//

import Foundation
import CoreLocation

extension Location {
  func distance(from: Location) -> CLLocationDistance {
    let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
    let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
    return from.distance(from: to)
  }
}

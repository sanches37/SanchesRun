//
//  RecordViewModel.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/17.
//

import Foundation
import NMapsMap

struct RecordViewModel {
  let run: Run
  
  var activeTime: String {
    run.activeTime.positionalTime
  }
  
  var averagePace: String {
    run.averagePace.positionalTime
  }
  
  var totalDistance: String {
    run.totalDistance.withMeter
  }
  
  var runPaths: [[NMGLatLng]] {
    run.runPaths
      .map {
        $0.map {
          NMGLatLng(
            lat: $0.latitude,
            lng: $0.longitude
          )
        }
      }
  }
  
  var centerLatitude: Double {
    let array = run.runPaths.flatMap { $0 }
    return array.reduce(0) { result, location in
      result + location.latitude
    } / Double(array.count)
  }
  
  var centerLongitude: Double {
    let array = run.runPaths.flatMap { $0 }
    return array.reduce(0) { result, location in
      result + location.longitude
    } / Double(array.count)
  }
}

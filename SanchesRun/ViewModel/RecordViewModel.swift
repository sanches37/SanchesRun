//
//  RunResultViewModel.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/06.
//

import Combine
import NMapsMap
import SwiftUI

class RecordViewModel: ObservableObject, MapAvailable {
  @Published var runPaths: [[CLLocation]] = []
  private var cancellable = Set<AnyCancellable>()
  init(runPaths: [[CLLocation]]) {
    self.runPaths = runPaths
  }
  
  deinit {
    print("RecordViewModel deinit")
  }
  
  func setUp(mapView: NMFMapView) {
    defaultSetting(mapView: mapView)
    focusPathLocation(mapView: mapView)
    updatePath(mapView: mapView)
  }
  func defaultSetting(mapView: NMFMapView) {
    mapView.zoomLevel = 14
    mapView.minZoomLevel = 13
  }
  
  func updatePath(mapView: NMFMapView) {
    let multipartPath = NMFMultipartPath()
    multipartPath.width = 10
    $runPaths
      .filter { !($0.last?.isEmpty ?? false) }
      .first()
      .map {
        $0.map { $0.map {
          NMGLatLng(
            lat: $0.coordinate.latitude,
            lng: $0.coordinate.longitude
          )}
        }
      }
      .sink {
        multipartPath.mapView = nil
        multipartPath.lineParts = $0.map {
          NMGLineString(points: $0)
        }
        multipartPath.colorParts.append(NMFPathColor(color: UIColor(Color.mediumseagreen)))
        multipartPath.mapView = mapView
      }
      .store(in: &cancellable)
  }
  
  func focusPathLocation(mapView: NMFMapView) {
    $runPaths
      .filter { !($0.last?.isEmpty ?? false) }
      .first()
      .map {
        let array = $0.flatMap { $0 }
        let centerLat =
        array
          .reduce(0) { result, location in
            result + location.coordinate.latitude
          } / Double(array.count)

        let centerLng =
        array
          .reduce(0) { result, location in
            result + location.coordinate.longitude
          } / Double(array.count)

        return NMGLatLng(lat: centerLat, lng: centerLng)
      }
      .sink {
        let cameraUpdate = NMFCameraUpdate(scrollTo: $0)
        mapView.moveCamera(cameraUpdate)
      }
      .store(in: &cancellable)
  }
}

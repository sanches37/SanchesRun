//
//  RunViewDelegate.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/03.
//

import Combine
import NMapsMap
import SwiftUI

struct MapOfRunViewDelegate: MapViewDelegate {
  let viewModel: RunViewModel
  
  func defaultSetting(mapView: NMFMapView) {
    mapView.zoomLevel = 17
    mapView.minZoomLevel = 13
  }
  func focusFirstLocation(mapView: NMFMapView) {
    viewModel.$userLocation
      .compactMap { $0 }
      .map {
        NMGLatLng(
          lat: $0.coordinate.latitude,
          lng: $0.coordinate.longitude
        )
      }
      .first()
      .sink {
        let cameraUpdate = NMFCameraUpdate(scrollTo: $0)
        mapView.moveCamera(cameraUpdate)
        mapView.positionMode = .direction
      }
      .store(in: &viewModel.cancellable)
  }
  
  func focusPathLocation(mapView: NMFMapView) {
    viewModel.$runPaths
      .compactMap { $0.last?.last }
      .map {
        NMGLatLng(
          lat: $0.coordinate.latitude,
          lng: $0.coordinate.longitude
        )
      }
      .sink {
        let cameraUpdate = NMFCameraUpdate(scrollTo: $0)
        cameraUpdate.animation = .easeOut
        mapView.moveCamera(cameraUpdate)
        mapView.positionMode = .direction
      }
      .store(in: &viewModel.cancellable)
  }
  
  func updatePath(mapView: NMFMapView) {
    let multipartPath = NMFMultipartPath()
    multipartPath.width = 10
    viewModel.$runPaths
      .filter { !($0.last?.isEmpty ?? true) }
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
      .store(in: &viewModel.cancellable)
  }
}

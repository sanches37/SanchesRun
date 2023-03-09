//
//  RecordMapView.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/10.
//

import SwiftUI
import NMapsMap
import Combine

struct RecordMapView: UIViewRepresentable {
  let runPaths: [[CLLocation]]
  let multipartPath = NMFMultipartPath()
  
  func makeUIView(context: Context) -> NMFMapView {
    let view = NMFMapView()
    setUp(mapView: view)
    return view
  }
  
  private func setUp(mapView: NMFMapView) {
    defaultSetting(mapView: mapView)
    focusAveragePath(mapView: mapView)
    updatePath(mapView: mapView)
  }
  
  private func defaultSetting(mapView: NMFMapView) {
    mapView.zoomLevel = 14
    mapView.minZoomLevel = 13
    multipartPath.width = 10
  }
  
  private func updatePath(mapView: NMFMapView) {
    let convertRunPaths =
    runPaths
      .map {
        $0.map {
          NMGLatLng(
            lat: $0.coordinate.latitude,
            lng: $0.coordinate.longitude
          )
        }
      }
    multipartPath.lineParts =
    convertRunPaths.map {
      NMGLineString(points: $0)
    }
    multipartPath.colorParts
      .append(NMFPathColor(color: UIColor(Color.mediumseagreen)))
    multipartPath.mapView = mapView
  }
  
  private func focusAveragePath(mapView: NMFMapView) {
    let array = runPaths.flatMap { $0 }
    let centerLat =
    array.reduce(0) { result, location in
      result + location.coordinate.latitude
    } / Double(array.count)
    
    let centerLng =
    array.reduce(0) { result, location in
      result + location.coordinate.longitude
    } / Double(array.count)
    
    let averagePath =  NMGLatLng(lat: centerLat, lng: centerLng)
    let cameraUpdate = NMFCameraUpdate(scrollTo: averagePath)
    mapView.moveCamera(cameraUpdate)
  }
  
  func updateUIView(_ uiView: NMFMapView, context: Context) {}
}

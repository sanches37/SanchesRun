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
  let runPaths: [[Location]]
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
    mapView.zoomLevel = 13
    mapView.minZoomLevel = 12
    multipartPath.width = 10
  }
  
  private func updatePath(mapView: NMFMapView) {
    let convertRunPaths =
    runPaths
      .map {
        $0.map {
          NMGLatLng(
            lat: $0.latitude,
            lng: $0.longitude
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
      result + location.latitude
    } / Double(array.count)
    
    let centerLng =
    array.reduce(0) { result, location in
      result + location.longitude
    } / Double(array.count)
    
    let averagePath =  NMGLatLng(lat: centerLat, lng: centerLng)
    let cameraUpdate = NMFCameraUpdate(scrollTo: averagePath)
    mapView.moveCamera(cameraUpdate)
  }
  
  func updateUIView(_ uiView: NMFMapView, context: Context) {}
}

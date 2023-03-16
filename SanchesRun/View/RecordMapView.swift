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
  @EnvironmentObject private var viewModel: RecordViewModel
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
    multipartPath.lineParts =
    viewModel.runPaths.map { NMGLineString(points: $0) }
    multipartPath.colorParts
      .append(NMFPathColor(color: UIColor(Color.mediumseagreen)))
    multipartPath.mapView = mapView
  }
  
  private func focusAveragePath(mapView: NMFMapView) {
    let averagePath =
    NMGLatLng(lat: viewModel.centerLatitude, lng: viewModel.centerLongitude)
    let cameraUpdate = NMFCameraUpdate(scrollTo: averagePath)
    mapView.moveCamera(cameraUpdate)
  }
  
  func updateUIView(_ uiView: NMFMapView, context: Context) {}
}

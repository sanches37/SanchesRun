//
//  RecordMapView.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/10.
//

import SwiftUI
import NMapsMap

struct RecordMapView: UIViewRepresentable {
  let viewModel: RecordViewModel
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
    addFirstAndLastPoint(mapView: mapView)
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
  
  private func addFirstAndLastPoint(mapView: NMFMapView) {
    addWindowView(mapView: mapView, position: viewModel.firstRunPath, color: .lightcoral)
    addWindowView(mapView: mapView, position: viewModel.lastRunPath, color: .cornflowerblue)
  }
  
  private func addWindowView(
    mapView: NMFMapView,
    position: NMGLatLng?,
    color: Color
  ) {
    guard let position = position else { return }
    let infoWindow = NMFInfoWindow()
    infoWindow.anchor = CGPoint(x: 0.5, y: 0.5)
    infoWindow.dataSource = CustomWindowView(color: UIColor(color))
    infoWindow.position = position
    infoWindow.open(with: mapView)
  }
  
  func updateUIView(_ uiView: NMFMapView, context: Context) {}
}

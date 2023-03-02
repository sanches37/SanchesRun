//
//  MapView.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/01.
//

import SwiftUI
import NMapsMap
import Combine

struct MapView: UIViewRepresentable {
  @EnvironmentObject private var viewModel: RunViewModel
  private let multipartPath = NMFMultipartPath()
  
  func makeUIView(context: Context) -> NMFMapView {
    let view = NMFMapView()
    defaultSetting(context: context, mapView: view)
    setProcess(context: context, mapView: view)
    return view
  }
  
  private func defaultSetting(context: Context, mapView: NMFMapView) {
    mapView.zoomLevel = 17
    mapView.minZoomLevel = 13
    mapView.positionMode = .direction
    
    multipartPath.width = 10
  }
  private func setProcess(context: Context, mapView: NMFMapView) {
    FocusFirstLocation(context: context, mapView: mapView)
    FocusRunLocation(context: context, mapView: mapView)
    updatePath(context: context, mapView: mapView)
  }
  
  private func FocusFirstLocation(context: Context, mapView: NMFMapView) {
    viewModel.$userLocation
      .compactMap { $0 }
      .first()
      .sink {
        let cameraUpdate = NMFCameraUpdate(scrollTo: $0)
        mapView.moveCamera(cameraUpdate)
      }
      .store(in: &context.coordinator.cancellable)
  }
  
  private func FocusRunLocation(context: Context, mapView: NMFMapView) {
    viewModel.$runPaths
      .compactMap { $0.last?.last }
      .sink {
        let cameraUpdate = NMFCameraUpdate(scrollTo: $0)
        cameraUpdate.animation = .easeOut
        mapView.moveCamera(cameraUpdate)
      }
      .store(in: &context.coordinator.cancellable)
  }
  
  private func updatePath(context: Context, mapView: NMFMapView) {
    viewModel.$runPaths
      .filter { !($0.last?.isEmpty ?? true) }
      .sink {
        multipartPath.mapView = nil
        multipartPath.lineParts = $0.map {
          NMGLineString(points: $0)
        }
        multipartPath.colorParts.append(NMFPathColor(color: UIColor.green))
        multipartPath.mapView = mapView
      }
      .store(in: &context.coordinator.cancellable)
  }
  
  func updateUIView(_ uiView: NMFMapView, context: Context) {}
  
  func makeCoordinator() -> Coordinator {
    MapView.Coordinator()
  }
  
  class Coordinator: NSObject {
    var cancellable = Set<AnyCancellable>()
  }
}

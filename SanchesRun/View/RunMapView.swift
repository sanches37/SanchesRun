//
//  MapView.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/01.
//

import SwiftUI
import NMapsMap
import Combine

struct RunMapView: UIViewRepresentable {
  @EnvironmentObject private var viewModel: RunViewModel
  let multipartPath = NMFMultipartPath()
  
  func makeUIView(context: Context) -> NMFMapView {
    let view = NMFMapView()
    setUp(context: context, mapView: view)
    return view
  }
  
  private func setUp(context: Context, mapView: NMFMapView) {
    defaultSetting(mapView: mapView)
    focusFirstLocation(context: context, mapView: mapView)
    focusPathLocation(context: context, mapView: mapView)
    updatePath(context: context, mapView: mapView)
    resetPath(context: context, mapView: mapView)
  }
  
  private func defaultSetting(mapView: NMFMapView) {
    mapView.zoomLevel = 17
    mapView.minZoomLevel = 13
    multipartPath.width = 10
  }
  private func focusFirstLocation(context: Context, mapView: NMFMapView) {
    viewModel.$focusLocation
      .compactMap { $0 }
      .map {
        NMGLatLng(
          lat: $0.latitude,
          lng: $0.longitude
        )
      }
      .sink {
        let cameraUpdate = NMFCameraUpdate(scrollTo: $0)
        mapView.moveCamera(cameraUpdate)
        mapView.positionMode = .direction
        mapView.positionMode = .normal
      }
      .store(in: &context.coordinator.cancellable)
  }
  
  private func focusPathLocation(context: Context, mapView: NMFMapView) {
    viewModel.$runPaths
      .compactMap { $0.last?.last }
      .map {
        NMGLatLng(
          lat: $0.latitude,
          lng: $0.longitude
        )
      }
      .sink {
        let cameraUpdate = NMFCameraUpdate(scrollTo: $0)
        cameraUpdate.animation = .easeOut
        mapView.moveCamera(cameraUpdate)
        mapView.positionMode = .direction
        mapView.positionMode = .normal
      }
      .store(in: &context.coordinator.cancellable)
  }
  
  private func updatePath(context: Context, mapView: NMFMapView) {
    viewModel.$runPaths
      .filter { !($0.last?.isEmpty ?? false) }
      .map {
        $0.map { $0.map {
          NMGLatLng(
            lat: $0.latitude,
            lng: $0.longitude
          )}
        }
      }
      .sink { result in
        multipartPath.mapView = nil
        multipartPath.lineParts = result.map {
          NMGLineString(points: $0)
        }
        multipartPath.colorParts.append(
          NMFPathColor(color: UIColor(Color.mediumseagreen))
        )
        multipartPath.mapView = mapView
      }
      .store(in: &context.coordinator.cancellable)
  }
  
  private func resetPath(context: Context, mapView: NMFMapView) {
    viewModel.$runPaths
      .dropFirst()
      .filter { $0.isEmpty }
      .sink { _ in
        multipartPath.mapView = nil
        multipartPath.mapView = mapView
      }
      .store(in: &context.coordinator.cancellable)
  }
  
  func updateUIView(_ uiView: NMFMapView, context: Context) {}
  
  func makeCoordinator() -> Coordinator {
    RunMapView.Coordinator()
  }
  
  final class Coordinator: NSObject {
    var cancellable = Set<AnyCancellable>()
    
    deinit {
      print("RunMapView deinit")
    }
  }
}

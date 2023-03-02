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
  private let pathOverlay = NMFPath()
  
  func makeUIView(context: Context) -> NMFMapView {
    let view = NMFMapView()
    setUp(context: context, mapView: view)
    updatePath(context: context, mapView: view)
    return view
  }
  
  private func setUp(context: Context, mapView: NMFMapView) {
    pathOverlay.color = UIColor.blue
    pathOverlay.width = 10
  }
  
  private func updatePath(context: Context, mapView: NMFMapView) {
    viewModel.$runPaths
      .dropFirst()
      .sink {
        pathOverlay.mapView = nil
        self.pathOverlay.path = NMGLineString(points: $0)
        pathOverlay.mapView = mapView
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

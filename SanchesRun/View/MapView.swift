//
//  MapView.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/01.
//

import SwiftUI
import NMapsMap

struct MapView<T: MapAvailable>: UIViewRepresentable {
  @EnvironmentObject private var viewModel: T
  
  func makeUIView(context: Context) -> NMFMapView {
    let view = NMFMapView()
    viewModel.setUp(mapView: view)
    return view
  }
 
  func updateUIView(_ uiView: NMFMapView, context: Context) {}
}

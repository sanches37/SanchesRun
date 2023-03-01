//
//  MapView.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/01.
//

import SwiftUI
import NMapsMap

struct MapView: UIViewRepresentable {
  @EnvironmentObject private var viewModel: RunViewModel
  
  func makeUIView(context: Context) -> NMFMapView {
    let view = NMFMapView()
    return view
  }
  
  func updateUIView(_ uiView: NMFMapView, context: Context) {}
  
  func makeCoordinator() -> Coordinator {
    MapView.Coordinator(viewModel: viewModel)
  }
  
  class Coordinator: NSObject {
    private let viewModel: RunViewModel
    
    init(viewModel: RunViewModel) {
      self.viewModel = viewModel
    }
  }
}

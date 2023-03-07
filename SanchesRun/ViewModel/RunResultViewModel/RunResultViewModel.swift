//
//  RunResultViewModel.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/06.
//

import Combine
import NMapsMap

class RunResultViewModel: ObservableObject, MapAvailable {
  @Published var runPaths: [[CLLocation]] = []
  var cancellable = Set<AnyCancellable>()
  private lazy var mapViewDelegate = MapOfRunResultViewDelegate(viewModel: self)
  
  func setUp(mapView: NMFMapView) {
    mapViewDelegate.defaultSetting(mapView: mapView)
    mapViewDelegate.focusPathLocation(mapView: mapView)
    mapViewDelegate.updatePath(mapView: mapView)
  }
}

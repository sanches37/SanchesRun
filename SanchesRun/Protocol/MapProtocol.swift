//
//  MapAvailable.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/03.
//

import NMapsMap

protocol MapAvailable: ObservableObject {
  func setUp(mapView: NMFMapView)
}

protocol MapViewDelegate {
  associatedtype T = MapAvailable
  var viewModel: T { get }
}

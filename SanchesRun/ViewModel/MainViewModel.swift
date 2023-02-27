//
//  MainViewModel.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/02/27.
//

import Combine

final class MainViewModel: ObservableObject {
  private let locationManager = LocationManager()
  private var cancellable = Set<AnyCancellable>()
  
  init() {
    fetchLocation()
  }
  
  private func fetchLocation() {
    locationManager.fetchCurrentLocation()
      .setFailureType(to: Error.self)
      .sink { [weak self] completion in
        self?.onReceiveCompletion("fetchLocation finished", completion)
      } receiveValue: { result in
        print("location: \(String(describing: result))")
      }
      .store(in: &cancellable)
  }
}

//
//  AppState.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/18.
//

import Foundation
import Combine

class AppState: ObservableObject {
  private let networkManager = NetworkManager()
  private let appVersionManager = AppVersionManager()
  private var cancellable = Set<AnyCancellable>()
  @Published var isAppUpdate = false
  
  init() {
    fetchAppVersion()
  }
  
  deinit {
    print("AppState Deinit")
  }
  
  private func fetchAppVersion() {
    guard appVersionManager.checkAppVersionDate else { return }
    networkManager.fetch(type: AppleAppModel.self, url: appVersionManager.appInfoURL)
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("fetchAppVersion finished")
        case let .failure(error):
          debugPrint(error.localizedDescription)
        }
      } receiveValue: { result in
        if self.appVersionManager.checkAppVersion(
          appVersion: result.results[0].version) {
          self.isAppUpdate = true
        }
      }
      .store(in: &cancellable)
  }
}

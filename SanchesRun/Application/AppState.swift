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
  private var cancellable = Set<AnyCancellable>()
  @Published private(set) var isAppUpdate = false
  
  init() {
    fetchAppVersion()
  }
  
  private func fetchAppVersion() {
    guard let info = Bundle.main.infoDictionary,
          let id = info["CFBundleIdentifier"] as? String else {
      return
    }
    
    let url = URL(string: "http://itunes.apple.com/kr/lookup?bundleId=\(id)")
    networkManager.fetch(type: AppleAppModel.self, url: url)
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("fetchAppVersion finished")
        case let .failure(error):
          debugPrint(error.localizedDescription)
        }
      } receiveValue: { result in
        self.checkAppVersion(appVersion: result.results[0].version)
      }
      .store(in: &cancellable)
  }
  
  private func checkAppVersion(appVersion: String) {
    guard let info = Bundle.main.infoDictionary,
          let currentVersion = info["CFBundleShortVersionString"] as? String,
          let appVersionInt = Int(appVersion.split(separator: ".").map { $0 }.joined()),
          let currentVersionInt = Int(currentVersion.split(separator: ".").map { $0 }.joined()) else {
      return
    }
    if appVersionInt > currentVersionInt {
      self.isAppUpdate = true
    }
  }
}

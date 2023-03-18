//
//  AppVersionManager.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/18.
//

import Foundation

struct AppVersionManager {
  var checkAppVersionDate: Bool {
    guard let date =
            UserDefaults.standard.value(forKey: UserDefaultsKey.appVersionDate) as? Date else {
      return true
    }
    if Date().compare(date.nextDay) == .orderedDescending {
      return true
    }
    return false
  }
  
  var appInfoURL: URL? {
    guard let info = Bundle.main.infoDictionary,
          let id = info["CFBundleIdentifier"] as? String else {
      return nil
    }
    return URL(string: "http://itunes.apple.com/kr/lookup?bundleId=\(id)")
  }
  
  func checkAppVersion(appVersion: String) -> Bool {
    guard let info = Bundle.main.infoDictionary,
          let currentVersion = info["CFBundleShortVersionString"] as? String,
          let appVersionInt = Int(appVersion.split(separator: ".").map { $0 }.joined()),
          let currentVersionInt = Int(currentVersion.split(separator: ".").map { $0 }.joined()) else {
      return false
    }
    return appVersionInt > currentVersionInt
  }
}

//
//  StoreProperty.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/18.
//

import Foundation

enum PropertyStore {
  static let appleId = "6446199498"
  static let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/\(appleId)")
}

enum UserDefaultsKey {
  static let appVersionDate = "appVersionDate"
}

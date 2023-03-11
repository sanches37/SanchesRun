//
//  PermissionDenied.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/12.
//

import Foundation

enum PermissionDenied {
  case location
  case motion
  case locationAndMotion
  
  var text: String {
    switch self {
    case .location:
      return "위치"
    case .motion:
      return "동작 및 피트니스"
    case .locationAndMotion:
      return "위치, 동작 및 피트니스"
    }
  }
}

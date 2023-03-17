//
//  TabViewItem.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/16.
//

import SwiftUI

enum TabViewItem: Hashable, CaseIterable {
  case run, record
  
  var iconName: String {
    switch self {
    case .run:
      return "figure.walk"
    case .record:
      return "calendar"
    }
  }
  
  var title: String {
    switch self {
    case .run:
      return "런닝"
    case .record:
      return "기록"
    }
  }
  
  var color: Color {
    switch self {
    case .run:
      return .cornflowerblue
    case .record:
      return .cornflowerblue
    }
  }
}

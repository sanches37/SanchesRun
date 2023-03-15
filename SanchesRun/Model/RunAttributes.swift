//
//  RunAttributes.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/16.
//

import SwiftUI
import ActivityKit

struct RunAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var time: TimeInterval
    var totalDistance: Double
    var oneKilometerPace: TimeInterval
  }
}

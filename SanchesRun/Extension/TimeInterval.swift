//
//  TimeInterval.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/01.
//

import Foundation

extension TimeInterval {
  var positionalTime: String {
    let formatter = DateComponentsFormatter()
    let oneHour: TimeInterval = 3600
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .pad
    formatter.allowedUnits =
    self >= oneHour ? [.hour, .minute, .second] : [.minute, .second]
    return formatter.string(from: self) ?? ""
  }
}

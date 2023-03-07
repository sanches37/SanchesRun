//
//  Date.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/08.
//

import Foundation

extension Date {
  func toDateTimeString(format: String = "yyyy년 MM월 dd일") -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter.string(from: self)
  }
}

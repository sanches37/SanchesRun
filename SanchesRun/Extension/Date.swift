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
  
  var fetchAllDates: [Date] {
    let calender = Calendar.current
    let startDate = calender.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    let range = calender.range(of: .day, in: .month, for: startDate)!
    return range.compactMap { day -> Date in
      return calender.date(byAdding: .day, value: day - 1, to: startDate)!
    }
  }
}

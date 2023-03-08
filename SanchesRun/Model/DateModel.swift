//
//  DateValue.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/08.
//

import Foundation

struct DateModel: Identifiable {
  var id = UUID().uuidString
  var day: Int
  var date: Date
}

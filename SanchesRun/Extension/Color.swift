//
//  Color.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/01.
//

import SwiftUI

extension Color {
  static let mediumseagreen = Color(hex: "3cb371")
  static let lightcoral = Color(hex: "f08080")
  static let lightslategray = Color(hex: "778899")
  static let palegoldenrod = Color(hex: "eee8aa")
}

extension Color {
  init(hex: String) {
    let lowerHex = hex.lowercased()
    let scanner = Scanner(string: lowerHex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}

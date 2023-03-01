//
//  PrimaryButtonStyle.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/01.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
  let fillColor: Color
  let labelColor: Color = .white
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .fontSize(20)
      .foregroundColor(labelColor)
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 8)
          .fill(fillColor)
      )
  }
}

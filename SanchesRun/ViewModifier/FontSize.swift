//
//  FontSize.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/01.
//

import SwiftUI

struct FontSize: ViewModifier {
  let size: CGFloat
  let weight: Font.Weight
  
  func body(content: Content) -> some View {
    content
      .font(.system(size: self.size, weight: self.weight))
  }
}

extension View {
  func fontSize(_ size: CGFloat, _ weight: Font.Weight = .regular) -> some View {
    self.modifier(FontSize(size: size, weight: weight))
  }
}

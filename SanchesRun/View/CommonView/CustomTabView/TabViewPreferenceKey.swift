//
//  TabViewPreferenceKey.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/16.
//

import SwiftUI

struct TabViewPreferenceKey: PreferenceKey {
  static var defaultValue: [TabViewItem] = []
  
  static func reduce(value: inout [TabViewItem], nextValue: () -> [TabViewItem]) {
    value += nextValue()
  }
}

struct TabViewModifier: ViewModifier {
  let tab: TabViewItem
  @Binding var selection: TabViewItem
  
  func body(content: Content) -> some View {
    content
      .opacity(selection == tab ? 1.0 : 0)
      .preference(key: TabViewPreferenceKey.self, value: [tab])
  }
}

extension View {
  func tabViewItem(tab: TabViewItem, selection: Binding<TabViewItem>) -> some View {
    modifier(TabViewModifier(tab: tab, selection: selection))
  }
}

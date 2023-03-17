//
//  TabViewPreferenceKey.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/16.
//

import SwiftUI

struct TabViewModifier: ViewModifier {
  let tab: TabViewItem
  @Binding var selection: TabViewItem
  
  func body(content: Content) -> some View {
    content
      .opacity(selection == tab ? 1.0 : 0)
  }
}

extension View {
  func tabViewItem(tab: TabViewItem, selection: Binding<TabViewItem>) -> some View {
    modifier(TabViewModifier(tab: tab, selection: selection))
  }
}

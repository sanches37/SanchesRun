//
//  CustomTabViewContainer.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/16.
//

import SwiftUI

struct CustomTabViewContainer<Content: View>: View {
  @Binding var selection: TabViewItem
  let content: Content
  @State private var tabs: [TabViewItem] = []
  
  init(selection: Binding<TabViewItem>, @ViewBuilder content: () -> Content) {
    self._selection = selection
    self.content = content()
  }
  var body: some View {
    VStack(spacing: 0) {
      ZStack {
        content
      }
      CustomTabView(tabs: tabs, selection: $selection)
    }
    .onAppear {
      self.tabs = TabViewItem.allCases
    }
  }
}

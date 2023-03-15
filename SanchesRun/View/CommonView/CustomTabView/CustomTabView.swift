//
//  CustomTabView.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/15.
//

import SwiftUI

struct CustomTabView: View {
  @Environment(\.colorScheme) var scheme
  let tabs: [TabViewItem]
  @Binding var selection: TabViewItem
  
  var body: some View {
    HStack {
      ForEach(tabs, id: \.self) { tab in
        tabView(tab: tab)
          .onTapGesture {
            switchToTab(tab: tab)
          }
      }
    }
    .padding(.horizontal)
    .background((scheme == .light ? Color.white : Color.black) .ignoresSafeArea(edges: .bottom))
  }
}

extension CustomTabView {
  private func tabView(tab: TabViewItem) -> some View {
    VStack(spacing: 5) {
      Image(systemName: tab.iconName)
        .fontSize(24)
      Text(tab.title)
        .fontSize(10, .semibold)
    }
    .foregroundColor(selection == tab ? tab.color : .lightslategray)
    .padding(.vertical, 8)
    .frame(maxWidth: .infinity)
  }
  
  private func switchToTab(tab: TabViewItem) {
    withAnimation(.easeOut) {
      selection = tab
    }
  }
}

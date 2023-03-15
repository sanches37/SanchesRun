//
//  ContentView.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/02/27.
//

import SwiftUI

enum ViewTab {
  case run
  case record
}

struct ContentView: View {
  @State private var selection: TabViewItem = .run
  
  var body: some View {
    NavigationView {
      CustomTabViewContainer(selection: $selection) {
        RunView()
          .tabViewItem(tab: .run, selection: $selection)
        RecordListView()
          .tabViewItem(tab: .record, selection: $selection)
      }
    }
    .navigationViewStyle(.stack)
  }
}

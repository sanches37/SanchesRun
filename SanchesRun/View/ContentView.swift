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
  @State private var selection: ViewTab = .run
  
  var body: some View {
    NavigationView {
      TabView(selection: $selection) {
        RunView()
          .tag(ViewTab.run)
          .tabItem {
            Image(systemName: "figure.walk")
          }
        RecordListView()
          .tag(ViewTab.record)
          .tabItem {
            Image(systemName: "calendar")
          }
      }
    }
    .navigationViewStyle(.stack)
  }
}

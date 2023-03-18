//
//  ContentView.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/02/27.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject private var appState: AppState
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
    .onReceive(appState.$isAppUpdate) { _ in
    }
  }
}

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
    .alert(isPresented: $appState.isAppUpdate) {
      updateAppAlert
    }
  }
  
  private var updateAppAlert: Alert {
    UserDefaults.standard.set(
      Date(),
      forKey: UserDefaultsKey.appVersionDate
    )
  
    return Alert(
      title: Text("최신버전 업데이트"),
      primaryButton: .default(Text("업데이트하기")) {
        if let url = PropertyStore.appStoreURL,
           UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(
            url,
            options: [:],
            completionHandler: nil
          )
        }
      },
      secondaryButton: .cancel(Text("취소"))
    )
  }
}

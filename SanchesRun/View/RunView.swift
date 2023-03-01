//
//  Main.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/02/27.
//

import SwiftUI

struct RunView: View {
  @StateObject private var viewModel = RunViewModel()
  var body: some View {
    VStack {
      MapView()
      TimerView()
    }
    .padding(.bottom, 20)
    .edgesIgnoringSafeArea(.top)
    .environmentObject(viewModel)
  }
}

struct RunView_Previews: PreviewProvider {
  static var previews: some View {
    RunView()
  }
}

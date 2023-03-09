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
    VStack(spacing: 14) {
      MapView<RunViewModel>()
      VStack(spacing: 14) {
        runInfo
        Divider()
        TimerView()
      }
      .padding(.horizontal)
    }
    .padding(.bottom, 20)
    .edgesIgnoringSafeArea(.top)
    .environmentObject(viewModel)
  }
  
  private var runInfo: some View {
    HStack {
      VStack(spacing: 2) {
        Text("페이스")
          .fontSize(14)
          .foregroundColor(Color.lightslategray)
        Text(viewModel.oneKilometerPace.positionalTime)
          .fontSize(30)
          .foregroundColor(Color.primary)
          .lineLimit(1)
          .minimumScaleFactor(0.1)
      }
      .frame(maxWidth: .infinity)
      VStack(spacing: 2) {
        Text("거리")
          .fontSize(14)
          .foregroundColor(Color.lightslategray)
        Text(viewModel.totalDistance.withMeter)
          .fontSize(30)
          .foregroundColor(Color.primary)
          .frame(maxWidth: .infinity)
          .lineLimit(1)
          .minimumScaleFactor(0.1)
      }
      .frame(maxWidth: .infinity)
    }
  }
}

struct RunView_Previews: PreviewProvider {
  static var previews: some View {
    RunView()
  }
}

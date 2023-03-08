//
//  RunResultView.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/06.
//

import SwiftUI

struct RecordView: View {
  let run: Run
  @StateObject private var viewModel: RecordViewModel
  
  init(run: Run) {
    self.run = run
    _viewModel = StateObject(wrappedValue: .init(runPaths: run.runPaths))
  }
  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      MapView<RecordViewModel>()
      VStack(alignment: .leading, spacing: 25) {
        HStack {
          Text("운동 시간 :")
          Text(run.activeTime.positionalTime)
        }
        HStack {
          Text("총거리 :")
          Text(run.totalDistance.withMeter)
        }
        HStack {
          Text("1km 페이스 :")
          Text(run.averagePace.positionalTime)
        }
      }
      .fontSize(30)
      .padding()
    }
    .environmentObject(viewModel)
    .navigationTitle("런닝 기록")
    .navigationBarTitleDisplayMode(.large)
  }
}

struct RecordView_Previews: PreviewProvider {
  static var previews: some View {
    RecordView(run: Run())
  }
}

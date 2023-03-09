//
//  RunResultView.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/06.
//

import SwiftUI

struct RecordView: View {
  let run: Run
  var body: some View {
    VStack(spacing: 18) {
      RecordMapView(runPaths: run.runPaths)
      runInfo
        .padding(.horizontal)
        .padding(.bottom, 25)
    }
    .navigationTitle("기록")
    .navigationBarTitleDisplayMode(.large)
  }
  
  @ViewBuilder
  private var runInfo: some View {
    VStack(spacing: 18) {
      VStack(spacing: 3) {
        Text("시간")
          .fontSize(18)
          .foregroundColor(Color.lightslategray)
        Text(run.activeTime.positionalTime)
          .fontSize(46)
          .foregroundColor(Color.primary)
          .lineLimit(1)
          .minimumScaleFactor(0.1)
      }
      Divider()
      HStack {
        VStack(spacing: 3) {
          Text("페이스")
            .fontSize(18)
            .foregroundColor(Color.lightslategray)
          Text(run.averagePace.positionalTime)
            .fontSize(40)
            .foregroundColor(Color.primary)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
        }
        .frame(maxWidth: .infinity)
        VStack(spacing: 2) {
          Text("거리")
            .fontSize(18)
            .foregroundColor(Color.lightslategray)
          Text(run.totalDistance.withMeter)
            .fontSize(40)
            .foregroundColor(Color.primary)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .frame(maxWidth: .infinity)
        }
      }
    }
    .frame(maxWidth: .infinity)
  }
}

struct RecordView_Previews: PreviewProvider {
  static var previews: some View {
    RecordView(run: Run())
  }
}

//
//  RunStatusBundle.swift
//  RunStatus
//
//  Created by tae hoon park on 2023/03/16.
//

import WidgetKit
import SwiftUI

struct RunStateView: View {
  let context: ActivityViewContext<RunAttributes>
  var body: some View {
    VStack(spacing: 0) {
      Text(context.attributes.startDate, style: .timer)
        .fontSize(36)
        .multilineTextAlignment(.center)
        .foregroundColor(Color.black)
        .lineLimit(1)
        .padding(12)
        .frame(maxHeight: .infinity)
      Divider()
      HStack(spacing: 0) {
        VStack(spacing: 1) {
          Text("거리")
            .fontSize(14)
            .foregroundColor(Color.lightslategray)
          Text(context.state.totalDistance)
            .fontSize(28)
            .foregroundColor(Color.black)
            .lineLimit(1)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        Divider()
          .frame(maxHeight: .infinity)
        VStack(spacing: 1) {
          Text("페이스")
            .fontSize(14)
            .foregroundColor(Color.lightslategray)
          Text(context.state.oneKilometerPace)
            .fontSize(28)
            .foregroundColor(Color.black)
            .frame(maxWidth: .infinity)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
      }
      .frame(maxHeight: .infinity)
    }
  }
}


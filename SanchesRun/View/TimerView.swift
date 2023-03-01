//
//  TimerView.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/01.
//

import SwiftUI

enum TimerState {
  case active
  case stop
  case pause
}

struct TimerView: View {
  @EnvironmentObject private var viewModel: RunViewModel
  private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  
  var body: some View {
    VStack {
      Text(viewModel.time.positionalTime)
        .fontSize(46)
        .foregroundColor(Color.primary)
      HStack(spacing: 16) {
        resetButton
        viewModel.timerState == .active ?
        AnyView(pauseButton) : AnyView(startButton)
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal)
    }
    .onReceive(timer) { _ in
      viewModel.timerUpdate()
    }
  }
  
  private var resetButton: some View {
    Button {
      viewModel.timerReset()
    } label: {
      Text("재설정")
        .frame(maxWidth: .infinity)
    }.buttonStyle(
      PrimaryButtonStyle(fillColor: .lightslategray)
    )
  }
  
  private var startButton: some View {
    Button {
      viewModel.timerStart()
    } label: {
      Text("시작")
        .frame(maxWidth: .infinity)
    }.buttonStyle(
      PrimaryButtonStyle(fillColor: .lightcoral)
    )
  }
  
  private var pauseButton: some View {
    Button {
      viewModel.timerPause()
    } label: {
      Text("중지")
        .frame(maxWidth: .infinity)
    }.buttonStyle(
      PrimaryButtonStyle(fillColor: .mediumseagreen)
    )
  }
}

struct TimerView_Previews: PreviewProvider {
  static var previews: some View {
    TimerView()
  }
}


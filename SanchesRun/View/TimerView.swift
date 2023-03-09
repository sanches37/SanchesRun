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
  @State private var shouldShowEndAlert = false
  private let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
  
  var body: some View {
    VStack(spacing: 14) {
      Text(viewModel.time.positionalTime)
        .fontSize(46)
        .foregroundColor(Color.primary)
        .lineLimit(1)
        .minimumScaleFactor(0.1)
      HStack(spacing: 16) {
        if viewModel.timerState != .active {
          endButton
        }
        viewModel.timerState == .active ?
        AnyView(pauseButton) : AnyView(startButton)
      }
      .frame(maxWidth: .infinity)
    }
    .onReceive(timer) { _ in
      viewModel.timerUpdate()
    }
    .alert(isPresented: $shouldShowEndAlert) {
      endAlert
    }
  }
  
  private var endButton: some View {
    Button {
      shouldShowEndAlert.toggle()
    } label: {
      Text("완 료")
        .frame(maxWidth: .infinity)
    }.buttonStyle(
      PrimaryButtonStyle(
        fillColor: viewModel.runPaths.isEmpty ? .lightslategray : .cornflowerblue )
    )
    .disabled(viewModel.runPaths.isEmpty)
  }
  
  private var startButton: some View {
    Button {
      viewModel.timerStart()
    } label: {
      Text("시 작")
        .frame(maxWidth: .infinity)
    }.buttonStyle(
      PrimaryButtonStyle(fillColor: .lightcoral)
    )
  }
  
  private var pauseButton: some View {
    Button {
      viewModel.timerPause()
    } label: {
      Text("중 지")
        .frame(maxWidth: .infinity)
    }.buttonStyle(
      PrimaryButtonStyle(fillColor: .mediumseagreen)
    )
  }
  
  private var endAlert: Alert {
    Alert(
      title: Text("종료 하시겠습니까?"),
      primaryButton: .default(Text("확인")) {
        viewModel.timerEnd() },
      secondaryButton: .cancel(Text("취소"))
    )
  }
}

struct TimerView_Previews: PreviewProvider {
  static var previews: some View {
    TimerView()
  }
}


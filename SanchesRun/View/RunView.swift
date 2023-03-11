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
      RunMapView()
        .overlay (
          focusButton
          ,alignment: .bottomTrailing
        )
        .alert(isPresented: $viewModel.islocationPermissionDenied) {
          permissionDeniedAlert
        }
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
  
  private var focusButton: some View {
    Button {
      viewModel.fetchLocationByButton()
    } label: {
      Image(systemName: "scope")
        .font(.body)
        .padding(10)
        .background(Color.white)
        .clipShape(Circle())
    }
    .padding()
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
  
  private var permissionDeniedAlert: Alert {
    Alert(
      title: Text("위치 허용이 되지 않았습니다."),
      message: Text("설정에서 위치 허용을 해주세요."),
      primaryButton: .default(Text("설정")) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!) },
      secondaryButton: .cancel(Text("취소"))
    )
  }
}

struct RunView_Previews: PreviewProvider {
  static var previews: some View {
    RunView()
  }
}

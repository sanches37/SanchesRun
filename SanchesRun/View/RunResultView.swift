//
//  RunResultView.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/06.
//

import SwiftUI

struct RunResultView: View {
  @StateObject private var viewModel = RunResultViewModel()
  @Environment(\.managedObjectContext) var viewContext
  @Environment(\.presentationMode) var presentationMode
  @FetchRequest(entity:Run.entity(), sortDescriptors: []) private var runs: FetchedResults<Run>
  
  var body: some View {
    NavigationView {
      VStack {
        MapView<RunResultViewModel>()
        Text("\(runs.last!.activeTime.positionalTime)")
        Text("\(runs.last!.totalDistance.withMeter)")
        Text("\(runs.last!.averagePace.positionalTime)")
      }
      .environmentObject(viewModel)
      .onAppear {
        viewModel.runPaths = runs.last!.runPaths
      }
      .navigationTitle("런닝 기록")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            presentationMode.wrappedValue.dismiss()
          } label: {
            Text("닫기")
          }
        }
      }
    }
  }
}

struct RunResultView_Previews: PreviewProvider {
  static var previews: some View {
    RunResultView()
  }
}

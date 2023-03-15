//
//  RecordListView.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/08.
//

import SwiftUI
import CoreData

struct RecordListView: View {
  @StateObject private var viewModel = RecordListViewModel()
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Run.startDate, ascending: true)],
    animation: .default) private var runs: FetchedResults<Run>
  @Environment(\.colorScheme) var scheme
  
  var body: some View {
    VStack {
      CustomDatePicker(
        currentDate: $viewModel.selectedDate,
        runingDates: Binding<[Date]>(
          get: { runs.map(\.wrappedStartDate) },
          set: { _ in }
        )
      )
      if viewModel.runsByDate(runs).isEmpty && scheme == .light {
        Rectangle()
          .frame(maxHeight: .infinity)
          .foregroundColor(Color(UIColor.secondarySystemBackground))
      } else {
        List {
          ForEach(viewModel.runsByDate(runs), id: \.id) { run in
            NavigationLink {
              RecordView(run: run)
            } label: {
              recordRow(run: run)
            }
          }
          .onDelete {
            viewModel.removeRun(runs, indexSet: $0)
          }
        }
      }
    }
    .padding()
  }
  
  private func recordRow(run: Run) -> some View {
    HStack {
      Text(run.wrappedStartDate
        .toDateTimeString(format: "a hh:mm")
      )
      .fontSize(18)
      Spacer()
      Text(run.totalDistance.withMeter)
        .fontSize(18)
        .foregroundColor(Color.lightslategray)
    }
    .padding(8)
  }
}

struct RecordListView_Previews: PreviewProvider {
  static var previews: some View {
    RecordListView()
  }
}

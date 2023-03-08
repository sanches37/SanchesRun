//
//  RecordListView.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/08.
//

import SwiftUI
import CoreData

struct RecordListView: View {
  @Environment(\.managedObjectContext) var viewContext
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Run.startDate, ascending: true)],
    animation: .default) private var runs: FetchedResults<Run>
  @State private var selectedDate = Date()
  var body: some View {
    VStack {
      CustomDatePicker(
        currentDate: $selectedDate,
        runingDates: Binding<[Date]>(
          get: { runs.map(\.wrappedStartDate) },
          set: { _ in }
        )
      )
      List {
        ForEach(runs.filter {
          $0.wrappedStartDate.toDateTimeString() == selectedDate.toDateTimeString()
        }, id: \.id) { run in
          NavigationLink {
            RecordView(run: run)
          } label: {
            recordRow(run: run)
          }
          
        }
      }
      Spacer()
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

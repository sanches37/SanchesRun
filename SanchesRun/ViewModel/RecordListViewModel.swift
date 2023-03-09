//
//  RecordListViewModel.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/09.
//

import SwiftUI

final class RecordListViewModel: ObservableObject {
  @Published var selectedDate = Date()
  
  func runsByDate(_ runs: FetchedResults<Run>) -> [FetchedResults<Run>.Element] {
    runs.filter { $0.wrappedStartDate.toDateTimeString() == selectedDate.toDateTimeString()}
  }
  
  func removeRun(_ runs: FetchedResults<Run>, indexSet: IndexSet) {
    guard let index = indexSet.first else { return }
    PersistenceController.shared.viewContext.delete(runsByDate(runs)[index])
    PersistenceController.shared.save()
  }
}

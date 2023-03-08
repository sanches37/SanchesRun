//
//  Task.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/08.
//

import Foundation

struct Task: Identifiable {
  var id = UUID().uuidString
  var title: String
  var time: Date = Date()
}

struct TaskMetaData: Identifiable {
  var id = UUID().uuidString
  var task: [Task]
  var taskDate: Date
}

func getSampleDate(offset: Int) -> Date {
  let calender = Calendar.current
  let date = calender.date(byAdding: .day, value: offset, to: Date())
  return date ?? Date()
}

var tasks: [TaskMetaData] = [
  TaskMetaData(task: [
    Task(title: "1")
  ], taskDate: getSampleDate(offset: 1)),
  TaskMetaData(task: [
    Task(title: "2")
  ], taskDate: getSampleDate(offset: -3)),
  TaskMetaData(task: [
    Task(title: "3")
  ], taskDate: getSampleDate(offset: -5)),
  TaskMetaData(task: [
    Task(title: "4")
  ], taskDate: getSampleDate(offset: -7)),
  TaskMetaData(task: [
    Task(title: "4")
  ], taskDate: getSampleDate(offset: -10))
]

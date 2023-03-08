//
//  CustomDatePicker.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/08.
//

import SwiftUI

struct CustomDatePicker: View {
  @Binding var currentDate: Date
  @Binding var runingDates: [Date]
  @State private var currentMonth = 0
  let days: [String] =
  ["일", "월", "화", "수", "목", "금", "토"]
  var body: some View {
    VStack(spacing: 20) {
      HStack(spacing: 30) {
        Text(currentDate.toDateTimeString(format: "yyyy년 M월"))
          .fontSize(18,.semibold)
        Spacer()
        Button {
          currentMonth -= 1
        } label: {
          Image(systemName: "chevron.left")
            .fontSize(20,.semibold)
        }
        Button {
          currentMonth += 1
        } label: {
          Image(systemName: "chevron.right")
            .fontSize(20,.semibold)
        }
      }
      .padding(.horizontal)
      HStack {
        ForEach(days, id: \.self) { day in
          Text(day)
            .fontSize(14)
            .foregroundColor(Color.gray)
            .frame(maxWidth: .infinity)
        }
      }
      let colums = Array(repeating: GridItem(.flexible()), count: 7)
      LazyVGrid(columns: colums, spacing: 10) {
        ForEach(extractDate) { value in
          cardView(value: value)
            .onTapGesture {
              currentDate = value.date
            }
        }
      }
      .onChange(of: currentMonth) { newValue in
        currentDate = getCurrentMonth
      }
    }
  }
  
  private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
    let calender = Calendar.current
    return calender.isDate(date1, inSameDayAs: date2)
  }
  
  @ViewBuilder
  private func cardView(value: DateModel) -> some View {
    VStack {
      if value.day != 0 {
        Text("\(value.day)")
          .fontSize(20)
          .foregroundColor(isSameDay(value.date, currentDate) ? .white : .primary)
          .frame(maxWidth: .infinity)
          .padding(4)
          .background(
            isSameDay(value.date, currentDate) ? AnyView(Circle().fill(.blue)) : AnyView(EmptyView())
          )
        Spacer()
        if let _ = runingDates.first(where: { date in
          return isSameDay(date, value.date)
        }) {
          Circle()
            .fill(Color.lightcoral)
            .frame(width: 7, height: 7)
        }
      }
    }
    .frame(height: 40, alignment: .top)
  }
  
  private var getCurrentMonth: Date {
    let calender = Calendar.current
    guard let currentMonth = calender.date(byAdding: .month, value: self.currentMonth, to: Date()) else { return Date() }
    return currentMonth
  }
  
  private var extractDate: [DateModel] {
    let calender = Calendar.current
    let currentMonth = getCurrentMonth
    var days = currentMonth.fetchAllDates.compactMap { date -> DateModel in
      let day = calender.component(.day, from: date)
      return DateModel(day: day, date: date)
    }
    let firstWeekday = calender.component(.weekday, from: days.first?.date ?? Date())
    for _ in 0..<firstWeekday - 1 {
      days.insert(DateModel(day: 0, date: Date()), at: 0)
    }
    return days
  }
}

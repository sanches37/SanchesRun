//
//  LiveActivityManager.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/17.
//

import Foundation
import ActivityKit

struct LiveActivityManager {
  @available(iOS 16.1, *)
  func add<T: ActivityAttributes>(
    _ attributes: T,
    _ contentState: T.ContentState) {
    do {
      let activity = try Activity<T>.request(
        attributes: attributes,
        contentState: contentState,
        pushType: nil
      )
      print("success id: \(activity.id)")
    } catch {
      debugPrint(error.localizedDescription)
    }
  }
  
  @available(iOS 16.1, *)
  func update<T: ActivityAttributes>(
    _ attributes: T,
    _ contentState: T.ContentState) {
    Task {
      for activity in Activity<T>.activities{
        await activity.update(using: contentState)
      }
    }
  }
  
  @available(iOS 16.1, *)
  func stop<T: ActivityAttributes>(_ attributes: T) {
    Task {
      for activity in Activity<T>.activities{
        await activity.end(dismissalPolicy: .immediate)
      }
    }
  }
}

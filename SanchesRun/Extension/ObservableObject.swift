//
//  ObservableObject.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/02/27.
//

import Combine

extension ObservableObject {
  func onReceiveCompletion(
    _ finishedMessage: String,
    _ completion: Subscribers.Completion<Error>
  ) {
    switch completion {
    case .finished:
      debugPrint(finishedMessage)
    case let .failure(error):
      debugPrint(error.localizedDescription)
    }
  }
}

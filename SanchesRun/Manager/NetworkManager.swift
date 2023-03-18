//
//  NetworkManager.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/18.
//

import Foundation
import Combine

struct NetworkManager {
  func fetch<T: Decodable>(type: T.Type, url: URL?) -> AnyPublisher<T, NetworkError> {
    guard let url = url else {
      return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
    }
    return URLSession.shared
      .dataTaskPublisher(for: url)
      .tryMap { data, response in
        let rangeOfSuccessState = 200...299
        guard let httpResponse = response as? HTTPURLResponse else {
          throw NetworkError.responseTypeFailed
        }
        guard (rangeOfSuccessState).contains(httpResponse.statusCode) else {
          throw NetworkError.responseFailed(httpResponse.statusCode)
        }
        guard !data.isEmpty else {
          throw NetworkError.dataNotfound
        }
        return data
      }
      .decode(type: T.self, decoder: JSONDecoder())
      .mapError { error in
        if let error = error as? NetworkError {
          return error
        } else {
          return NetworkError.unknown(error.localizedDescription)
        }
      }
      .eraseToAnyPublisher()
  }
}

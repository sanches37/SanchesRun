//
//  NetworkError.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/18.
//

import Foundation

enum NetworkError: Error, LocalizedError {
  case invalidURL
  case unknown(String)
  case responseTypeFailed
  case responseFailed(Int)
  case dataNotfound
  
  var errorDescription: String {
    switch self {
    case .invalidURL:
        return "잘못된 URL입니다."
    case .unknown:
      return "알 수 없는 에러입니다."
    case .responseTypeFailed:
      return "리스폰스 타입 에러입니다."
    case let .responseFailed(stateCode):
      return "에러 StateCode: \(stateCode)"
    case .dataNotfound:
      return "data를 전달 받지 못했습니다."
    }
  }
}

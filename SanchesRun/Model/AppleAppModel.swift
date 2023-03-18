//
//  VersionModel.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/18.
//

import Foundation

struct AppleAppModel: Decodable {
  let results: [VersionModel]
}

struct VersionModel: Decodable {
  let version: String
}

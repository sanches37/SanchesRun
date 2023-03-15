//
//  LocationModel.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/15.
//

import Foundation

public class Location: NSObject, NSCoding {
  enum Key: String {
    case latitude, longitude
  }
  
  public static var supportsSecureCoding: Bool = true
  var latitude: Double
  var longitude: Double
  
  init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }
  
  public func encode(with coder: NSCoder) {
    coder.encode(latitude, forKey: Key.latitude.rawValue)
    coder.encode(longitude, forKey: Key.longitude.rawValue)
  }
  
  required public convenience init?(coder: NSCoder) {
    let latitude = coder.decodeDouble(forKey: Key.latitude.rawValue)
    let longitude = coder.decodeDouble(forKey: Key.longitude.rawValue)
    self.init(latitude: latitude, longitude: longitude)
  }
}

//
//  NMGLatLng.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/06.
//

import NMapsMap

extension NMGLatLng {
  enum Key: String {
    case lat, lng
  }
  
  @objc(_)class Helper: NSObject, NSCoding {
    var nMGLatLng: NMGLatLng
    
    init(lat: Double, lng: Double) {
      self.nMGLatLng = NMGLatLng(lat: lat, lng: lng)
      super.init()
    }
    
    func encode(with coder: NSCoder) {
      coder.encode(nMGLatLng.lat, forKey: Key.lat.rawValue)
      coder.encode(nMGLatLng.lng, forKey: Key.lng.rawValue)
    }
    
    required convenience init?(coder: NSCoder) {
      guard let lat =
              coder.decodeObject(forKey: Key.lat.rawValue) as? Double,
            let lng =
              coder.decodeObject(forKey: Key.lng.rawValue) as? Double else {
        return nil
      }
      self.init(lat: lat, lng: lng)
    }
  }
}

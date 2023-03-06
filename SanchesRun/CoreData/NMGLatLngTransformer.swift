//
//  NMGLatLngTransformer.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/06.
//

import NMapsMap

class NMGLatLngTransformer: ValueTransformer {
  override public class func transformedValueClass() -> AnyClass {
    return NMGLatLng.self
  }
  
  override public class func allowsReverseTransformation() -> Bool {
    return true
  }
  
  override public func transformedValue(_ value: Any?) -> Any? {
    guard let value = value as? NMGLatLng else { return nil }
    
    do {
      return try NSKeyedArchiver.archivedData(
        withRootObject: value,
        requiringSecureCoding: true
      )
    } catch {
      return nil
    }
  }
  override public func reverseTransformedValue(_ value: Any?) -> Any? {
    guard let data = value as? Data else { return nil }
    
    do {
      return try NSKeyedUnarchiver.unarchivedObject(
        ofClass: NMGLatLng.Helper.self,
        from: data
      )
    } catch {
      return nil
    }
  }
}

extension NMGLatLngTransformer {
  static let name = NSValueTransformerName(rawValue: String(describing: NMGLatLngTransformer.self))
  
  public static func register() {
    let transformer = NMGLatLngTransformer()
    ValueTransformer.setValueTransformer(transformer, forName: name)
  }
}

//
//  Run+CoreDataProperties.swift
//  
//
//  Created by tae hoon park on 2023/03/15.
//
//

import Foundation
import CoreData

@objc(Run)
public class Run: NSManagedObject {}

extension Run {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Run> {
    return NSFetchRequest<Run>(entityName: "Run")
  }
  
  @NSManaged public var activeTime: Double
  @NSManaged public var averagePace: Double
  @NSManaged public var runPaths: [[Location]]
  @NSManaged public var totalDistance: Double
  @NSManaged public var startDate: Date?
  @NSManaged public var id: String?
  
  public var wrappedStartDate: Date {
    startDate ?? Date()
  }
}

extension Run: Identifiable {}

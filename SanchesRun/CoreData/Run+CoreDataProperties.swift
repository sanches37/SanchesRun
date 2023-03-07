//
//  Run+CoreDataProperties.swift
//  
//
//  Created by tae hoon park on 2023/03/07.
//
//

import Foundation
import CoreData
import CoreLocation

@objc(Run)
public class Run: NSManagedObject {}

extension Run {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Run> {
        return NSFetchRequest<Run>(entityName: "Run")
    }
    @NSManaged public var activeTime: Double
    @NSManaged public var averagePace: Double
    @NSManaged public var totalDistance: Double
    @NSManaged public var runPaths: [[CLLocation]]
}

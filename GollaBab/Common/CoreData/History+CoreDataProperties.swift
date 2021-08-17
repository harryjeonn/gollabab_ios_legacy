//
//  History+CoreDataProperties.swift
//  
//
//  Created by 전현성 on 2021/08/17.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var date: String?
    @NSManaged public var items: [String]
    @NSManaged public var result: String?
    @NSManaged public var title: String?

}

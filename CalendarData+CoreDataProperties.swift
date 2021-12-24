//
//  CalendarData+CoreDataProperties.swift
//  GollaBab
//
//  Created by 전현성 on 2021/12/28.
//
//

import Foundation
import CoreData


extension CalendarData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CalendarData> {
        return NSFetchRequest<CalendarData>(entityName: "CalendarData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var memo: String?

}

extension CalendarData : Identifiable {

}

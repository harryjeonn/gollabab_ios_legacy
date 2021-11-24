//
//  SearchHistory+CoreDataProperties.swift
//  
//
//  Created by 전현성 on 2021/11/28.
//
//

import Foundation
import CoreData


extension SearchHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchHistory> {
        return NSFetchRequest<SearchHistory>(entityName: "SearchHistory")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?

}

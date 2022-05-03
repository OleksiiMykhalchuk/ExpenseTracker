//
//  Category+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 4/30/22.
//
//

import Foundation
import CoreData

extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String

}

extension Category: Identifiable {
}

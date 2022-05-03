//
//  Expense+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 4/30/22.
//
//

import Foundation
import CoreData

extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var date: Date
    @NSManaged public var amount: Double
    @NSManaged public var category: String

}

extension Expense: Identifiable {

}

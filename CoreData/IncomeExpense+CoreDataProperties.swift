//
//  IncomeExpense+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/12/22.
//
//

import Foundation
import CoreData


extension IncomeExpense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IncomeExpense> {
        return NSFetchRequest<IncomeExpense>(entityName: "IncomeExpense")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: String
    @NSManaged public var date: Date
    @NSManaged public var type: Bool

}

extension IncomeExpense : Identifiable {

}

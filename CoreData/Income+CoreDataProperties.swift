//
//  Income+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 4/30/22.
//
//

import Foundation
import CoreData


extension Income {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Income> {
        return NSFetchRequest<Income>(entityName: "Income")
    }

    @NSManaged public var name: String
    @NSManaged public var amount: Double
    @NSManaged public var date: Date

}

extension Income : Identifiable {

}

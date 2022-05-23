//
//  IncomeCategory+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/12/22.
//
//

import Foundation
import CoreData

extension IncomeCategory {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<IncomeCategory> {
    return NSFetchRequest<IncomeCategory>(entityName: "IncomeCategory")
  }
  @NSManaged public var id: String
  @NSManaged public var name: String

}

extension IncomeCategory: Identifiable {

}

//
//  ShouldoEntity+CoreDataProperties.swift
//  Shouldo
//
//  Created by woogie on 22/05/2019.
//  Copyright © 2019 Jaeuk Yun. All rights reserved.
//
//

import Foundation
import CoreData


extension ShouldoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShouldoEntity> {
        return NSFetchRequest<ShouldoEntity>(entityName: "Shouldo")
    }

    @NSManaged public var dayOfTheWeek: String?
    @NSManaged public var isFinished: String?
    @NSManaged public var task: String?

}

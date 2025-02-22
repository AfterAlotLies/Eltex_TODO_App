//
//  UserNotesEntity+CoreDataProperties.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 24.12.2024.
//
//

import Foundation
import CoreData


extension UserNotesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserNotesEntity> {
        return NSFetchRequest<UserNotesEntity>(entityName: "UserNotesEntity")
    }

    @NSManaged public var date: String
    @NSManaged public var descriptionNote: String
    @NSManaged public var id: UUID
    @NSManaged public var isCompleted: Bool
    @NSManaged public var task: String
    @NSManaged public var time: String
    @NSManaged public var ofUserEntity: UserEntity?

}

extension UserNotesEntity : Identifiable {

}

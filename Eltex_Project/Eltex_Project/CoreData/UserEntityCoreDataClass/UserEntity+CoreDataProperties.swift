//
//  UserEntity+CoreDataProperties.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 20.12.2024.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var ofNotesEntity: NSSet?

}

// MARK: Generated accessors for ofNotesEntity
extension UserEntity {

    @objc(addOfNotesEntityObject:)
    @NSManaged public func addToOfNotesEntity(_ value: UserNotesEntity)

    @objc(removeOfNotesEntityObject:)
    @NSManaged public func removeFromOfNotesEntity(_ value: UserNotesEntity)

    @objc(addOfNotesEntity:)
    @NSManaged public func addToOfNotesEntity(_ values: NSSet)

    @objc(removeOfNotesEntity:)
    @NSManaged public func removeFromOfNotesEntity(_ values: NSSet)

}

extension UserEntity : Identifiable {

}

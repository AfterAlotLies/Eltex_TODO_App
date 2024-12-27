//
//  UserNotesService.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 24.12.2024.
//

import Combine
import CoreData

// MARK: - UserNotesServiceErrors
enum UserNotesServiceErrors: Error {
    case userNotFound
    case failedToSave
}

// MARK: - UserNotesService
final class UserNotesService {
    private let entityName: String = "UserNotesEntity"
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Eltex_Project")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Add New Note for User
    func addNewNoteForUser(by userId: UUID, noteData: Note) -> AnyPublisher<Bool, Never> {
        Future { promise in
            let userFetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            userFetchRequest.predicate = NSPredicate(format: "id == %@", userId as CVarArg)
            
            do {
                if let user = try self.context.fetch(userFetchRequest).first {
                    let newNote = UserNotesEntity(context: self.context)
                    newNote.id = noteData.noteId
                    newNote.task = noteData.noteName
                    newNote.descriptionNote = noteData.noteDescription
                    newNote.date = noteData.noteDate
                    newNote.time = noteData.noteTime
                    newNote.isCompleted = noteData.isCompleted
                    newNote.ofUserEntity = user
                    
                    user.addToOfNotesEntity(newNote)
                    
                    try self.context.save()
                    promise(.success(true))
                } else {
                    promise(.success(false))
                }
            } catch {
                promise(.success(false))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Get All Notes for User by ID
    func getAllNotesForUser(by userId: UUID) -> AnyPublisher<[UserNotesEntity], Never> {
        let fetchRequest: NSFetchRequest<UserNotesEntity> = UserNotesEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ofUserEntity.id == %@", userId as CVarArg)
        
        return Future { promise in
            do {
                let notes = try self.context.fetch(fetchRequest)
                promise(.success(notes))
            } catch {
                promise(.success([]))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Delete Note For User by ID
    func deleteNote(for userId: UUID, by noteId: UUID) -> AnyPublisher<Bool, Never> {
        Future { promise in
            let userFetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            userFetchRequest.predicate = NSPredicate(format: "id == %@", userId as CVarArg)
            do {
                let users = try self.context.fetch(userFetchRequest)
                guard let user = users.first else {
                    promise(.success(false))
                    return
                }
                
                if let noteToDelete = user.ofNotesEntity?.first(where: { ($0 as? UserNotesEntity)?.id == noteId }) as? UserNotesEntity {
                    self.context.delete(noteToDelete)
                    try self.context.save()
                    promise(.success(true))
                } else {
                    promise(.success(false))
                }
            } catch {
                promise(.success(false))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Mark Not as Completed
    func markNoteAsCompleted(for userId: UUID, by noteId: UUID) -> AnyPublisher<Bool, Never> {
        Future { promise in
            let fetchRequest: NSFetchRequest<UserNotesEntity> = UserNotesEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "ofUserEntity.id == %@ AND id == %@", userId as CVarArg, noteId as CVarArg)
            
            do {
                let results = try self.context.fetch(fetchRequest)
                if let noteToUpdate = results.first {
                    noteToUpdate.isCompleted = true
                    try self.context.save()
                    promise(.success(true))
                } else {
                    promise(.success(false))
                }
            } catch {
                promise(.success(false))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Update Note For User by ID
    func updateNoteForUser(by userId: UUID, noteId: UUID, updatedNoteData: Note) -> AnyPublisher<Bool, Never> {
        Future { promise in
            let userFetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            userFetchRequest.predicate = NSPredicate(format: "id == %@", userId as CVarArg)
            
            do {
                if let user = try self.context.fetch(userFetchRequest).first {
                    let notesFetchRequest: NSFetchRequest<UserNotesEntity> = UserNotesEntity.fetchRequest()
                    notesFetchRequest.predicate = NSPredicate(format: "id == %@ AND ofUserEntity == %@", noteId as CVarArg, user)
                    
                    if let noteToUpdate = try self.context.fetch(notesFetchRequest).first {
                        noteToUpdate.task = updatedNoteData.noteName
                        noteToUpdate.descriptionNote = updatedNoteData.noteDescription
                        noteToUpdate.date = updatedNoteData.noteDate
                        noteToUpdate.time = updatedNoteData.noteTime
                        noteToUpdate.isCompleted = updatedNoteData.isCompleted
                        try self.context.save()
                        promise(.success(true))
                    } else {
                        promise(.success(false))
                    }
                } else {
                    promise(.success(false))
                }
            } catch {
                promise(.success(false))
            }
        }
        .eraseToAnyPublisher()
    }
}

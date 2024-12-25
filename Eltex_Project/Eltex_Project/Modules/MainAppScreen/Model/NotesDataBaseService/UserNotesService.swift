//
//  UserNotesService.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 24.12.2024.
//

import Combine
import CoreData

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
    func addNewNoteForUser(by userId: UUID, noteData: Note) {
        let userFetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "id == %@", userId as CVarArg)
        
        do {
            if let user = try context.fetch(userFetchRequest).first {
                let newNote = UserNotesEntity(context: context)
                newNote.id = noteData.noteId
                newNote.task = noteData.noteName
                newNote.descriptionNote = noteData.noteDescription
                newNote.date = noteData.noteDate
                newNote.time = noteData.noteTime
                newNote.isCompleted = noteData.isCompleted
                newNote.ofUserEntity = user
                
                user.addToOfNotesEntity(newNote)
                
                try context.save()
            } else {
                print("User not found.")
            }
        } catch {
            print("Failed to add note: \(error.localizedDescription)")
        }
    }

    // MARK: - Get All Notes for User by ID
    func getAllNotesForUser(by userId: UUID) -> [UserNotesEntity] {
        let fetchRequest: NSFetchRequest<UserNotesEntity> = UserNotesEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ofUserEntity.id == %@", userId as CVarArg)
        
        do {
            let notes = try context.fetch(fetchRequest)
            return notes
        } catch {
            print("Failed to fetch notes: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteNote(for userId: UUID, by noteId: UUID) {
        let userFetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "id == %@", userId as CVarArg)
        
        do {
            let users = try context.fetch(userFetchRequest)
            guard let user = users.first else {
                print("Пользователь не найден.")
                return
            }
            
            if let noteToDelete = user.ofNotesEntity?.first(where: { ($0 as? UserNotesEntity)?.id == noteId }) as? UserNotesEntity {
                context.delete(noteToDelete)
                try context.save()
                print("Заметка успешно удалена.")
            } else {
                print("Заметка не найдена.")
            }
        } catch {
            print("Ошибка при удалении заметки: \(error.localizedDescription)")
        }
    }
    
    func markNoteAsCompleted(for userId: UUID, by noteId: UUID) {
        let fetchRequest: NSFetchRequest<UserNotesEntity> = UserNotesEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ofUserEntity.id == %@ AND id == %@", userId as CVarArg, noteId as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let noteToUpdate = results.first {
                noteToUpdate.isCompleted = true
                try context.save()
                print("Заметка обновлена как выполненная.")
            } else {
                print("Заметка не найдена.")
            }
        } catch {
            print("Ошибка при обновлении заметки: \(error.localizedDescription)")
        }
    }

    func updateNoteForUser(by userId: UUID, noteId: UUID, updatedNoteData: Note) {
        let userFetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "id == %@", userId as CVarArg)
        
        do {
            if let user = try context.fetch(userFetchRequest).first {
                let notesFetchRequest: NSFetchRequest<UserNotesEntity> = UserNotesEntity.fetchRequest()
                notesFetchRequest.predicate = NSPredicate(format: "id == %@ AND ofUserEntity == %@", noteId as CVarArg, user)
                
                if let noteToUpdate = try context.fetch(notesFetchRequest).first {
                    noteToUpdate.task = updatedNoteData.noteName
                    noteToUpdate.descriptionNote = updatedNoteData.noteDescription
                    noteToUpdate.date = updatedNoteData.noteDate
                    noteToUpdate.time = updatedNoteData.noteTime
                    noteToUpdate.isCompleted = updatedNoteData.isCompleted
                    try context.save()
                } else {
                    print("Note not found.")
                }
            } else {
                print("User not found.")
            }
        } catch {
            print("Failed to update note: \(error.localizedDescription)")
        }
    }
}

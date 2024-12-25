//
//  NotesRepository.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 24.12.2024.
//

import Combine
import Foundation

final class NotesRepository {
    
    private let userNotesService: UserNotesService
    private let userInfo: UserInfo
    
    private(set) var notesPublisher = CurrentValueSubject<[Note], Never>([])
    private(set) var newNotePublisher = CurrentValueSubject<Note?, Never>(nil)
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        self.userNotesService = UserNotesService()
    }
    
    func getAllNoteForUser() {
        guard let userId = userInfo.id else { return }
        let userNotes = userNotesService.getAllNotesForUser(by: userId)
        
        let notes: [Note] = userNotes.map { userData in
            Note(noteId: userData.id,
                 noteName: userData.task,
                 noteDate: userData.date,
                 noteTime: userData.time,
                 noteDescription: userData.descriptionNote,
                 isCompleted: userData.isCompleted)
        }
        
        notesPublisher.send(notes)
    }
    
    func addNewNoteForUser(newNote: Note) {
        guard let userId = userInfo.id else { return }
        
        userNotesService.addNewNoteForUser(by: userId, noteData: newNote)
        
        newNotePublisher.value = newNote
    }
    
    func deleteNoteForUser(noteId: UUID) {
        guard let userId = userInfo.id else { return }
        
        userNotesService.deleteNote(for: userId, by: noteId)
        
        getAllNoteForUser()
    }
    
    func markNoteCompleted(noteId: UUID) {
        guard let userId = userInfo.id else { return }
        
        userNotesService.markNoteAsCompleted(for: userId, by: noteId)
        
        getAllNoteForUser()
    }
    
    func updateNoteForUser(noteData: Note) {
        guard let userId = userInfo.id else { return }
        print(noteData.noteId)
        userNotesService.updateNoteForUser(by: userId, noteId: noteData.noteId, updatedNoteData: noteData)
        
        getAllNoteForUser()
    }
}

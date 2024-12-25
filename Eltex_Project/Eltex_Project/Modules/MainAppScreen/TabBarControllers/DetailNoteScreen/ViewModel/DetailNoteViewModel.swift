//
//  DetailNoteViewModel.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 25.12.2024.
//

import Combine
import Foundation

final class DetailNoteViewModel {
    
    private let notesRepository: NotesRepository
    
    let editNoteAction = PassthroughSubject<Note, Never>()
    let setNewNoteAction = PassthroughSubject<Note, Never>()
    let closeDetailViewAction = PassthroughSubject<Void, Never>()
    
    init(notesRepository: NotesRepository) {
        self.notesRepository = notesRepository
    }
    
    func deleteNote(noteId: UUID) {
        notesRepository.deleteNoteForUser(noteId: noteId)
        closeDetailViewAction.send()
    }
    
    func markNoteCompleted(noteId: UUID) {
        notesRepository.markNoteCompleted(noteId: noteId)
        closeDetailViewAction.send()
    }
    
    func editnote(note: Note) {
        editNoteAction.send(note)
    }
}

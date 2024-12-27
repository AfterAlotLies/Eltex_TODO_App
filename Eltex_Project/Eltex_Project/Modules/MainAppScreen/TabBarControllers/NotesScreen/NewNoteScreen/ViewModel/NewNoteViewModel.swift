//
//  NewNoteViewModel.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 24.12.2024.
//

import Combine
import Foundation

final class NewNoteViewModel {
    
    @Published private(set) var errorMessage: String = ""
    
    private let notesRepository: NotesRepository
    private var choosenNote: Note?
    
    let noteCreatedPublisher = PassthroughSubject<Void, Never>()
    let noteEditedPublisher = PassthroughSubject<Note?, Never>()
    
    init(notesRepository: NotesRepository, choosenNote: Note?) {
        self.notesRepository = notesRepository
        self.choosenNote = choosenNote
    }
    
    func addNewNote(note: Note) {
        guard !note.noteName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !note.noteDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !note.noteDate.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !note.noteTime.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Fill all fields to create note"
            return
        }
        if checkCorrectDate(note) {
            notesRepository.addNewNoteForUser(newNote: note)
            closeScreen()
        } else {
            return
        }
    }
    
    func closeScreen() {
        noteCreatedPublisher.send()
    }
    
    func cancelEditing() {
        noteEditedPublisher.send(nil)
    }
    
    func saveEditing(for newNote: Note) {
        guard !newNote.noteName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !newNote.noteDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !newNote.noteDate.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !newNote.noteTime.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Fill all fields to create note"
            return
        }
        if checkCorrectDate(newNote) {
            notesRepository.updateNoteForUser(noteData: newNote)
            noteEditedPublisher.send(newNote)
        } else {
            return
        }
    }
}

private extension NewNoteViewModel {
    
    func checkCorrectDate(_ note: Note) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let selectedDate = dateFormatter.date(from: note.noteDate) else {
            errorMessage = "Invalid date format"
            return false
        }
        
        let today = Calendar.current.startOfDay(for: Date())
        if selectedDate < today {
            errorMessage = "Date cannot be in the past"
            return false
        }
        
        return true
    }
}

//
//  NoteListViewModel.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 23.12.2024.
//

import Combine
import Foundation

final class NoteListViewModel {
    
    @Published private(set) var fetchedUserNotes: [Note] = []
    
    private let notesRepository: NotesRepository
    private var subscriptions: Set<AnyCancellable> = []
    
    private var userNotes: [Note] = []
    
    let addNewNoteShowAction = PassthroughSubject<Void, Never>()
    let showNoteDetailsAction = PassthroughSubject<Note, Never>()
    
    init(notesRepository: NotesRepository) {
        self.notesRepository = notesRepository
        setupBinding()
    }
    
    func showAddNewNote() {
        addNewNoteShowAction.send()
    }
    
    func showNoteDetails(_ note: Note) {
        showNoteDetailsAction.send(note)
    }
}

private extension NoteListViewModel {
    
    func setData() {
        notesRepository.getAllNoteForUser()
    }
    
    func setupBinding() {
        notesRepository.notesPublisher
            .sink { [weak self] notes in
                guard let self = self else { return }
                self.userNotes.removeAll()
                self.userNotes += notes
                self.filterNotes()
            }
            .store(in: &subscriptions)
        
        notesRepository.newNotePublisher
            .sink { [weak self] newNote in
                guard let self = self,
                let note = newNote else {
                    return
                }
                self.userNotes.append(note)
                self.filterNotes()
            }
            .store(in: &subscriptions)
    }
    
    func filterNotes() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let today = Calendar.current.startOfDay(for: Date())
        
        let validNotes = userNotes.compactMap { note -> (Note, Date)? in
            guard let date = dateFormatter.date(from: note.noteDate) else {
                return nil
            }
            return (note, date)
        }
        
        let sortedNotes = validNotes.sorted { left, right in
            let leftDate = left.1
            let rightDate = right.1
            
            let leftIsPast = leftDate < today
            let rightIsPast = rightDate < today
            
            if leftIsPast && !rightIsPast {
                return true
            }
            
            if !leftIsPast && rightIsPast {
                return false
            }
            return leftDate < rightDate
        }
        
        fetchedUserNotes = sortedNotes.map { $0.0 }
    }
}

//
//  CalendarViewModel.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 26.12.2024.
//

import Combine
import Foundation

final class CalendarViewModel {
    @Published private(set) var visibleUserNote: [Note]?
    @Published private(set) var userNotes: [Note] = []
    
    private let notesRepository: NotesRepository
    private var subscriptions: Set<AnyCancellable> = []
    private var selectedDate: Date?
    
    let showDetailNoteAction = PassthroughSubject<Note, Never>()
    
    init(notesRepository: NotesRepository) {
        self.notesRepository = notesRepository
        setupBindings()
    }
    
    func filterNote(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let filteredNotes = userNotes.filter {
                if let noteDate = dateFormatter.date(from: $0.noteDate) {
                    let startOfNoteDate = Calendar.current.startOfDay(for: noteDate)
                    return startOfNoteDate == date
                }
                return false
            }
        
        visibleUserNote = filteredNotes
    }
    
    func showDetailNote(with note: Note) {
        showDetailNoteAction.send(note)
    }
    
    func setSelectedDate(with date: Date) {
        selectedDate = date
    }
}

private extension CalendarViewModel {
    
    func setupBindings() {
        notesRepository.notesPublisher
            .sink { [weak self] notes in
                guard let self = self else { return }
                self.userNotes = notes
                if let selectedDate = self.selectedDate {
                    self.filterNote(with: selectedDate)
                } else {
                    let today = Calendar.current.startOfDay(for: Date())
                    self.filterNote(with: today)
                }
            }
            .store(in: &subscriptions)
        
        notesRepository.newNotePublisher
            .sink { [weak self] newNote in
                guard let self = self,
                let note = newNote else {
                    return
                }
                self.userNotes.append(note)
                if let selectedDate = self.selectedDate {
                    self.filterNote(with: selectedDate)
                } else {
                    let today = Calendar.current.startOfDay(for: Date())
                    self.filterNote(with: today)
                }
            }
            .store(in: &subscriptions)
    }
}

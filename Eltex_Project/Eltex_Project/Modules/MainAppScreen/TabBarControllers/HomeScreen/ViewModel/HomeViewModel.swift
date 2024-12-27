//
//  HomeViewModel.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 23.12.2024.
//

import Combine
import Foundation

final class HomeViewModel {
    @Published private(set) var userInfo: UserInfo
    @Published private(set) var noteSections: [NoteSection] = []
    
    private var userNotes: [Note] = []
    
    private let notesRepository: NotesRepository
    private var subscriptions: Set<AnyCancellable> = []
    
    let detailNotePublisher = PassthroughSubject<Note, Never>()
    
    init(userInfo: UserInfo, notesRepository: NotesRepository) {
        self.notesRepository = notesRepository
        self.userInfo = userInfo
        setupBindings()
        setUserNotes()
    }
    
    func showDetail(with note: Note) {
        detailNotePublisher.send(note)
    }
}

private extension HomeViewModel {
    
    func setupBindings() {
        notesRepository.notesPublisher
            .sink { [weak self] notes in
                guard let self = self else { return }
                self.userNotes.removeAll()
                self.userNotes += notes
                self.splitNotes()
            }
            .store(in: &subscriptions)
        
        notesRepository.newNotePublisher
            .sink { [weak self] newNote in
                guard let self = self,
                      let note = newNote else {
                    return
                }
                self.userNotes.append(note)
                self.splitNotes()
            }
            .store(in: &subscriptions)
    }
    
    func setUserNotes() {
        notesRepository.getAllNoteForUser()
    }
    
    func splitNotes() {
        let (uncompletedNotes, completedNotes) = getNearestNotes()
        
        var sections: [NoteSection] = []
        
        if !uncompletedNotes.isEmpty {
            sections.append(NoteSection(title: "Uncompleted Tasks", notes: uncompletedNotes))
        }
        
        if !completedNotes.isEmpty {
            sections.append(NoteSection(title: "Completed Tasks", notes: completedNotes))
        }
        
        noteSections = sections
    }
    
    func getNearestNotes() -> ([Note], [Note]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let sortedNotes = userNotes.sorted { note1, note2 in
            guard let date1 = dateFormatter.date(from: note1.noteDate),
                  let date2 = dateFormatter.date(from: note2.noteDate) else {
                return false
            }
            return date1 < date2
        }
        
        let completedNotes = sortedNotes.filter { $0.isCompleted }
        let uncompletedNotes = sortedNotes.filter { !$0.isCompleted }
        
        let nearestCompleted = Array(completedNotes.prefix(2))
        let nearestUncompleted = Array(uncompletedNotes.prefix(2))
        
        return (nearestUncompleted, nearestCompleted)
    }
}

//
//  HomeViewModel.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 23.12.2024.
//

import Combine

final class HomeViewModel {
    @Published private(set) var userInfo: UserInfo
    @Published private(set) var noteSections: [NoteSection] = []
    
    private var userNotes: [Note] = []
    
    private let notesRepository: NotesRepository
    private var subscriptions: Set<AnyCancellable> = []
    
    init(userInfo: UserInfo, notesRepository: NotesRepository) {
        self.notesRepository = notesRepository
        self.userInfo = userInfo
        setupBindings()
        setUserNotes()
    }
}

private extension HomeViewModel {
    
    func setupBindings() {
        notesRepository.notesPublisher
            .sink { [weak self] notes in
                guard let self = self else { return }
                self.userNotes += notes
                self.splitNotes()
            }
            .store(in: &subscriptions)
        
    }
    
    func setUserNotes() {
        notesRepository.getAllNoteForUser()
        notesRepository.addNewNoteForUser()
    }
    
    func splitNotes() {
        let completedNotes = userNotes.filter { $0.isCompleted }
        let uncompletedNotes = userNotes.filter { !$0.isCompleted }
        
        var sections: [NoteSection] = []
        
        if !uncompletedNotes.isEmpty {
            sections.append(NoteSection(title: "Uncompleted Task", notes: uncompletedNotes))
        }
        
        if !completedNotes.isEmpty {
            sections.append(NoteSection(title: "Completed Task", notes: completedNotes))
        }
        
        noteSections = sections
    }
}

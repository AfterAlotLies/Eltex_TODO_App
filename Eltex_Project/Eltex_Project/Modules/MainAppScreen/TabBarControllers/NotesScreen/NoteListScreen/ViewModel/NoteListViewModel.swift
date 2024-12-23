//
//  NoteListViewModel.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 23.12.2024.
//

import Combine

final class NoteListViewModel {
    
    let addNewNoteShowAction = PassthroughSubject<Void, Never>()
    
    func showAddNewNote() {
        addNewNoteShowAction.send()
    }
}

//
//  NotesRepository.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 24.12.2024.
//

import Combine
import Foundation

final class NotesRepository {
    let notesPublisher = CurrentValueSubject<[Note], Never>([])
    
    func getAllNoteForUser() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.notesPublisher.value = [Note(noteName: "Task 1", noteDate: "Tommorow", noteTime: "10:30pm", noteDescription: "Hello", isCompleted: false)]
        }
    }
    
    func addNewNoteForUser() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.notesPublisher.value = [Note(noteName: "Task 2", noteDate: "Tommorow", noteTime: "10:30pm", noteDescription: "Hello", isCompleted: false)]
        }
    }
}

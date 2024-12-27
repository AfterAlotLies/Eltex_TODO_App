//
//  NotesRepository.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 24.12.2024.
//

import Combine
import Foundation

// MARK: - NotesRepository
final class NotesRepository {
    
    private let userNotesService: UserNotesService
    private let userInfo: UserInfo
    
    private(set) var notesPublisher = CurrentValueSubject<[Note], Never>([])
    private(set) var newNotePublisher = CurrentValueSubject<Note?, Never>(nil)
    private var subscriptions: Set<AnyCancellable> = []
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        self.userNotesService = UserNotesService()
    }
    
    // MARK: - Get Notes
    func getAllNoteForUser() {
        guard let userId = userInfo.id else { return }
        
        userNotesService.getAllNotesForUser(by: userId)
            .map { userNotes in
                userNotes.map { userData in
                    Note(noteId: userData.id,
                         noteName: userData.task,
                         noteDate: userData.date,
                         noteTime: userData.time,
                         noteDescription: userData.descriptionNote,
                         isCompleted: userData.isCompleted)
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notes in
                self?.notesPublisher.send(notes)
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Add New Note
    func addNewNoteForUser(newNote: Note) {
        guard let userId = userInfo.id else { return }
        
        userNotesService.addNewNoteForUser(by: userId, noteData: newNote)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] success in
                if success {
                    self?.newNotePublisher.send(newNote)
                }
            })
            .store(in: &subscriptions)
    }
    
    // MARK: - Delete Note
    func deleteNoteForUser(noteId: UUID) {
        guard let userId = userInfo.id else { return }
        
        userNotesService.deleteNote(for: userId, by: noteId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                if success {
                    self?.getAllNoteForUser()
                }
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Mark Completed Note
    func markNoteCompleted(noteId: UUID) {
        guard let userId = userInfo.id else { return }
        
        userNotesService.markNoteAsCompleted(for: userId, by: noteId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                if success {
                    self?.getAllNoteForUser()
                }
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Update Note Data
    func updateNoteForUser(noteData: Note) {
        guard let userId = userInfo.id else { return }
        userNotesService.updateNoteForUser(by: userId, noteId: noteData.noteId, updatedNoteData: noteData)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                if success {
                    self?.getAllNoteForUser()
                }
            }
            .store(in: &subscriptions)
    }
}

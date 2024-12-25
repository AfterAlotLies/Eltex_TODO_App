//
//  Note.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 23.12.2024.
//
import Foundation

struct Note {
    let noteId: UUID
    let noteName: String
    var noteDate: String
    let noteTime: String
    let noteDescription: String
    let isCompleted: Bool
}

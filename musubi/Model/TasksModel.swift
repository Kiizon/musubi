//
//  TasksModel.swift
//  musubi
//
//  Created by Kish Dizon on 2025-11-12.
//
import Foundation

struct TaskItem:  Identifiable, Codable, Equatable{
    let id: UUID
    let name: String
    var isDone: Bool
    
    init(id: UUID = UUID(), name: String, isDone: Bool = false) { // default false on creation
        self.id = id
        self.name = name
        self.isDone = isDone
    }
}


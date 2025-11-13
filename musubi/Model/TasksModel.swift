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
    let date: Date
    
    init(id: UUID = UUID(), name: String, isDone: Bool = false, date: Date) { // default false on creation
        self.id = id
        self.name = name
        self.isDone = isDone
        self.date = date
    }
}


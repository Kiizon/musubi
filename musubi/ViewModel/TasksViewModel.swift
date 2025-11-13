//
//  TasksViewModel.swift
//  musubi
//
//  Created by Kish Dizon on 2025-11-12.
//
import Foundation
import Combine

final class TasksViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = []
    
    func addTask(name: String) {
        let task = TaskItem(id: UUID(), name: name, isDone: false, date: Date())
        tasks.append(task)
    }
    func toggleDone(for id: UUID) {
        guard let index = tasks.firstIndex(where: {$0.id == id}) else { return }
        tasks[index].isDone.toggle()
    }
    
    
}

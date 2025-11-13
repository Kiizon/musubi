//
//  TasksViewModel.swift
//  musubi
//
//  Created by Kish Dizon on 2025-11-12.
//
import Foundation
import Combine

final class TasksViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = [] {
        didSet {
            saveTasks()
        }
    }
    
    private let storage_key = "tasks_storage"
    
    init() {
        loadTasks()
    }
    
    //MARK: - Persistence
    private func saveTasks() {
        do {
            let data = try JSONEncoder().encode(tasks)
            UserDefaults.standard.set(data, forKey: storage_key)
        } catch {
            print("Failed to save tasks: \(error)")
        }
    }
    private func loadTasks() {
        guard let data = UserDefaults.standard.data(forKey: storage_key) else { return }
        do {
            let savedTasks = try JSONDecoder().decode([TaskItem].self, from: data)
            self.tasks = savedTasks
        } catch {
            print("Failed to load tasks: \(error)" )
        }
    }
    // MARK: - API
    func addTask(name: String, date: Date) {
        let task = TaskItem(id: UUID(), name: name, isDone: false, date: date)
        tasks.append(task)
    }
    func toggleDone(for id: UUID) {
        guard let index = tasks.firstIndex(where: {$0.id == id}) else { return }
        tasks[index].isDone.toggle()
    }
    func renameTask(for id: UUID, to newName: String) {
        guard let index = tasks.firstIndex(where: {$0.id == id}) else { return }
        tasks[index].name = newName
    }
    func deleteTask(for id: UUID) {
        tasks.removeAll(where: {$0.id == id})
    }
    
    
}

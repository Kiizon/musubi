//
//  TasksView.swift
//  musubi
//
//  Created by Kish Dizon on 2025-11-12.
//
import SwiftUI

struct TasksView: View {
    @EnvironmentObject var vm: TasksViewModel
    
    @State private var text: String = ""
    @State private var date: Date = Date()
    private var tasksForDate: [TaskItem] {
        let calendar = Calendar.current
        return vm.tasks.filter { task in
            calendar.isDate(task.date, inSameDayAs: date)
        }
    }
    private func shiftDay(by value: Int){
        if let newDate = Calendar.current.date(byAdding: .day, value: value, to: date) {
            date = newDate
        }
    }
    private func formatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: { shiftDay(by: -1) }) {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.plain)
                Spacer()
                Text(formatter(date: date))
                Spacer()
                Button(action: { shiftDay(by: 1) }) {
                    Image(systemName: "chevron.right")
                }
                .buttonStyle(.plain)
            }
            .padding(2)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 6) {
                    ForEach(tasksForDate) { task in
                        HStack {
                            Button(action: { vm.toggleDone(for: task.id)}) {
                                Image(systemName: task.isDone ? "checkmark.square" : "square")
                            }
                            .buttonStyle(.plain)
                            Text(task.name)
                        }
                    }
                }
            }
            HStack {
                Image(systemName: "plus")
                TextField("New Task", text: $text)
                    .onSubmit {
                        if !text.isEmpty {
                            vm.addTask(name: text)
                            text = ""
                        }
                    }
                    .textFieldStyle(.plain)
                    .padding(5)

            }
            
        }
        .padding(12)
    }
}


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
    var body: some View {
        VStack {
            HStack {
                Text("To Do List:")
                Spacer()
            }

            List(vm.tasks) { task in
                HStack {
                    Button(action: { vm.toggleDone(for: task.id) } ){
                        Image(systemName: task.isDone ? "checkmark.square.fill" : "square")
                    }
                    .buttonStyle(.plain)
                    Text(task.name)
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

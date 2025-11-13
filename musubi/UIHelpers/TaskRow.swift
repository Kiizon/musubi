//
//  TaskRow.swift
//  musubi
//
//  Created by Kish Dizon on 2025-11-12.
//
import SwiftUI

struct TaskRow: View {
    let task: TaskItem
    var onToggleDone: () -> Void
    var onRename: (String) -> Void
    var onDelete: () -> Void
    
    
    
    @State private var isEditing: Bool = false
    @State private var draftName: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Button(action: onToggleDone) {
                Image(systemName: task.isDone ? "checkmark.square.fill" : "square")
            }
            .buttonStyle(.plain)
            
            if isEditing {
                TextField("Task", text: $draftName)
                    .textFieldStyle(.plain)
                    .focused($isFocused)
                    .onSubmit {
                        isEditing = false
                        isFocused = false
                        onRename(draftName)
                    }
                    .onAppear {
                        
                        if draftName.isEmpty {
                            draftName = task.name
                        }
                        isFocused = true
                    }
            } else {
                Text(task.name)
                    .onTapGesture(count: 2) {
                        draftName = task.name
                        isEditing = true
                        isFocused = true
                    }
            }
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "x.circle")
            }
            .buttonStyle(.plain)
            
            
        }
    }
}

//
//  HeaderRowView.swift
//  Assessment 2-3
//
//  Created by Connor Moloney on 15/03/2024.
//

import SwiftUI

struct HeaderRowView: View {
    
    // Environment variable to dismiss view
    @Environment( \.dismiss) private var dismiss
    
    // Closure property to define action for save/update button
    var saveAction: () -> Void
    
    // Enum to represent button text
    enum ButtonState {
        case save
        case update
        case edit
    }
    
    // Button state to determine the button text
    var buttonState: ButtonState
    
    var body: some View {
        // Header row
        HStack {
            // Cancel button
            Button() {
                dismiss()
            } label: {
                Text("Cancel")
            }
            
            Spacer()
            
            // Save, update or edit button depending on buttonState passed
            Button() {
                // Call the closure to perform save/update action
                saveAction()
                dismiss()
            } label: {
                Text(buttonText)
            }
        }
    }
    // Computed property to determine button text based on buttonState
    private var buttonText: String {
        switch buttonState {
        case .save:
            return "Save"
        case .update:
            return "Update"
        case .edit:
            return "Edit"
        }
    }
}

#Preview {
    HeaderRowView(saveAction: {}, buttonState: .save)
}

//
//  CheckBoxView.swift
//  Assessment 2-3
//
//  Created by Connor Moloney on 04/03/2024.
//

import SwiftUI

struct CheckboxView: View {
    // Binding to control the state of the checkbox
    @Binding var isChecked: Bool
    
    var body: some View {
        // Button to toggle the isChecked state when tapped/
        Button {
            isChecked.toggle()
        } label: {
            // Display a green checkmark if isChecked is true, otherwise display an empty red square
            if isChecked {
                Image(systemName: "checkmark.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width:25, height: 25)
                    .foregroundColor( .green)
            } else {
                Image(systemName: "square")
                    .resizable()
                    .scaledToFit()
                    .frame(width:25, height: 25)
                    .foregroundColor( .red)
            }
        }
        // Set the content shape of the button to Rectangle to ensure it responds to taps on the entire area
        .contentShape( Rectangle() )
    }
}


#Preview {
    CheckboxView(isChecked: Binding.constant(true))
}

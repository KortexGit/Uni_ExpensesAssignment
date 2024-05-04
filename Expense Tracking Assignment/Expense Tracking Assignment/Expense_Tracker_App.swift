//
//  Assessment_2_3App.swift
//  Assessment 2-3
//
//  Created by Connor Moloney on 17/02/2024.
//

import SwiftUI

@main
struct Expense_Tracker_App: App {
    
    // Create a state object to manage the expenses data
    @StateObject private var data = Expenses()

    var body: some Scene {
        // Define the main window group for the app
        WindowGroup {
            // Set up the root view of the app and pass the expenses data to it
            RootView(data: self.data) {
                // Save the expenses data asynchronously
                Expenses.save(expenses: data.expenses) { result in
                    // Handle the result of the save operation
                    if case .failure(let error) = result {
                        // Terminate the app if there is an error while saving, displaying the error message
                        fatalError(error.localizedDescription)
                    }
                }
            }
            // Execute the code when the root view appears
            .onAppear {
                // Load the expenses data asynchronously
                Expenses.load { result in
                    // Handle the result of the load operation
                    switch result {
                    case .success(let expenses):
                        // Assign the loaded expenses to the data object
                        self.data.expenses = expenses
                    case .failure (let error):
                        // Terminate the app if there is an error while loading, displaying the error message
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
    }
}

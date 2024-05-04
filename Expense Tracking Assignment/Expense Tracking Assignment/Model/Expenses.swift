//
//  Expenses.swift
//  Assessment 2-3
//
//  Created by Connor Moloney on 25/02/2024.
//

import Foundation

class Expenses: ObservableObject {
    // Published array of Expense objects to track changes and updates views
    @Published var expenses: [Expense] = []
    
    // Published integer to track the sorting option for isPaid
    @Published var filterIsPaid: Int = 2
    
    // Published integer to track the sorting option
    @Published var sortBy: Int = 0 {
        didSet {
            // Sort expenses based on the selected option
            if (sortBy == 0) {
                expenses.sort {
                    $0.incurredDate < $1.incurredDate
                }
            } else {
                expenses.sort {
                    $0.incurredDate > $1.incurredDate
                }
            }
        }
    }
    
    // Computed property to filter expenses based on isPaid status
    var filteredExpenses: [Expense] {
        switch filterIsPaid {
        case 0: // Outstanding
            return expenses.filter { !$0.isPaid }
        case 1: // Paid
            return expenses.filter { $0.isPaid }
        default: // All
            return expenses
        }
    }
    
    // Function to get the file URL for saving and loading expenses data
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
            .appendingPathComponent("expenses.data")
    }
    
    // Function to save expenses data to a file asynchronously
    static func save(expenses: [Expense], completion: @escaping(Result<Int, Error>) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            do {
                // Encode the data to JSON
                let data = try JSONEncoder().encode(expenses)
                // Get the file URL
                let outfile = try fileURL()
                // Write data to the file
                try data.write(to: outfile)
                // Completion handler with success result
                DispatchQueue.main.async {
                    completion(.success(expenses.count))
                }
            } catch {
                // Completion handler with failure result if error occurs
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // Function to load expenses data from a file asynchronously
    static func load(completion: @escaping(Result<[Expense], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                // Get the file URL
                let fileURL = try fileURL()
                // Check if the file exists
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    // If file does not exist return an empty array
                    DispatchQueue.main.async {
                        completion( .success([]))
                    }
                    return
                }
                
                // Decode expenses data from JSON
                let newExpense = try JSONDecoder().decode([Expense].self, from: file.availableData)
                // Completion handler with loaded expenses data
                DispatchQueue.main.async {
                    completion( .success(newExpense))
                }
            } catch {
                // Completion handler with failure result if error occurs
                DispatchQueue.main.async {
                    completion( .failure(error))
                }
            }
        }
    }
    
    // Function to remove an expense from the expenses array
    func removeExpense(expense: Expense) {
        if let index = expenses.firstIndex(of: expense) {
            expenses.remove(at: index)
        }
    }
}

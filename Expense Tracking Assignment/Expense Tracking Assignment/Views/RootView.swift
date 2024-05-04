//
//  ContentView.swift
//  Assessment 2-3
//
//  Created by Connor Moloney on 17/02/2024.
//

import SwiftUI

struct RootView: View {
    // State variable to control the presentation of the create expense view
    @State var createExpenseShowing: Bool = false
    // Text for searching expenses
    @State var searchText = ""
    // Observed object to track changes in expenses data
    @ObservedObject var data: Expenses
    // Environment variable to observe scene phase changes
    @Environment(\.scenePhase) private var scenePhase
    
    // Call to save expenses data function attached to parent rootView
    let saveAction: () -> Void
    
    var body: some View {
        // Navigation view to manage navigation hierarchy
        NavigationView{
            // List view to display expenses
            List(data.filteredExpenses.filter(
                {"\($0.expenseSummary)".localizedCaseInsensitiveContains(searchText) || searchText.isEmpty})) { expense in
                    // Navigation link to navigate to expense detail view
                    NavigationLink(destination: ExpenseDetailView(expense: expense, saveAction: saveAction)) {
                        // Expense row view to display expense details
                        ExpenseRowView(expense: expense)
                    }
                    // Swipe action to delete expense
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        // Delete expense button
                        Button {
                            data.removeExpense(expense: expense)
                        } label: {
                            Text("Delete")
                        }
                        .tint( .red)
                    }
                }
                .navigationTitle("Expenses") // Set navigation title
                .navigationBarTitleDisplayMode( .inline) // Set navigation bar display mode
                .toolbar {
                    // Toolbar items group for leading side
                    ToolbarItemGroup (placement: .topBarLeading) {
                        // Menu for filtering options
                        Menu {
                            // Picker for filtering by pay status
                            Picker(selection: $data.filterIsPaid, label: Text("Pay Status")) {
                                Text("Outstanding").tag(0)
                                Text("Paid").tag(1)
                                Text("All").tag(2)
                            }
                        } label: {
                            // Image for filter menu
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .frame(width: 30, height: 30)
                        }
                        
                        // Menu for sort options
                        Menu {
                            // Picker for sorting by incurred date
                            Picker(selection:$data.sortBy, label: Text("Sort by Date")) {
                                Text("Incurred Ascending").tag(0)
                                Text("Incurred Descending").tag(1)
                            }
                        } label: {
                            // Label for sort menu
                            Label("Sort", systemImage:"arrow.up.arrow.down")
                        }
                    }
                    
                    // Toolbar items group for trailing side
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        // Button to present create expense view
                        Button {
                            // Toggle state variable to show create expense view
                            createExpenseShowing.toggle()
                        } label: {
                            // Image for create expense button
                            Image(systemName: "plus.circle")
                                .frame(width: 30, height: 30)
                        }
                        // Sheet to present create expense view
                        .sheet(isPresented: $createExpenseShowing) {
                            ExpenseAddView(expensesList: data)
                        }
                    }
                }
            // Search functionality
                .searchable(text: $searchText)
        }
        // Observing scene phase changes to save data when app becomes inactive
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

#Preview {
    RootView(data: Expenses(),
             saveAction: {})
}

//
//  expenseRowView.swift
//  Assessment 2-3
//
//  Created by Connor Moloney on 25/02/2024.
//

import SwiftUI

struct ExpenseRowView: View {
    // ObservedObject property to manage the expense displayed in the row
    @ObservedObject var expense: Expense
    
    var body: some View {
        HStack {
            // Display expenses summary
            Text("Summary: \(expense.expenseSummary)")
            
            Spacer()
            
            // Display total amount with or without VAT based on includingVAT value
            Text(expense.includeVAT ? "Total inc VAT: £\(expense.totalAmountIncludingVAT)" : "Total exc VAT: £\(String(format: "%.2f", expense.totalAmount))")
            
            Spacer()
            
            Text("Paid:")
            
            // Display Paid: text with a custom checkbox to toggle the isPaid property
            CheckboxView(isChecked: $expense.isPaid)
                .onTapGesture {
                    // Toggle the isChecked property of the checkbox
                    expense.isPaid.toggle()
                    
                    // Update the paidDate property based on isPaid
                    if expense.isPaid {
                        expense.paidDate = Date()
                    } else {
                        expense.paidDate = nil
                    }
                }
            // Ensure the tap gesture doesn't propagate to the NavigationLink
                .contentShape(Rectangle())
        }
    }
}

#Preview {
    ExpenseRowView(expense: Expense(expenseSummary: "Fuel", totalAmount: 19.99, isPaid: false, includeVAT: false, incurredDate: Date.init(), addedDate: Date.init(), paidDate: nil))
}

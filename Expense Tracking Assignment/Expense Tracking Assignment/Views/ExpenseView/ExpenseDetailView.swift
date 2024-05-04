//
//  expenseDetailView.swift
//  Assessment 2-3
//
//  Created by Connor Moloney on 25/02/2024.
//

import SwiftUI

struct ExpenseDetailView: View {
    // State object to manage the expense details
    @StateObject var expense: Expense
    
    // State variables for handling the image selection
    @State private var showingImagePicker: Bool = false
    @State private var showingImageFullscreen: Bool = false
    // State variable to hold the displayed image
    @State var image: Image?
    
    // State variable to activate edit screen
    @State private var showingEditScreen: Bool = false
    
    // Environment variable to observe scene phase changes
    @Environment(\.scenePhase) private var scenePhase
    
    // Call to save expenses data function attached to parent rootView
    let saveAction: () -> Void
    
    var body: some View {
        VStack {
            // Header row
            HeaderRowView(saveAction: {showingEditScreen = true}, buttonState: .edit)
            
            Spacer()
            
            // Added date and VAT toggle
            HStack {
                Text("Date: \(expense.addedDate, formatter: Helper.dateFormatter)")
                
                Spacer()
                
                // Toggle for including VAT
                Toggle(isOn: $expense.includeVAT) {
                    Text("VAT")
                }
                .frame(width: 90)
            }
            
            // Expense Summary
            Text("Expense Summary: \(expense.expenseSummary)")
            
            // Total Amount with VAT
            VStack {
                Divider()
                
                // Display total amount with or without VAT based on user selection
                expense.includeVAT ?
                VStack (spacing: 8) {
                    Text("Amount (exc VAT): £\(String(format: "%.2f", expense.totalAmount))")
                    Text("Amount (inc VAT): £\(expense.totalAmountIncludingVAT)") // Already formatted to 2SF when the VAT is added
                }
                :
                VStack {
                    Text("Amount (exc VAT): £\(String(format: "%.2f", expense.totalAmount))")
                    Text("")
                }
                Divider()
            }
            
            // Dates
            VStack (spacing: 8) {
                // Incurred Date
                Text("Date Incurred: \(expense.incurredDate, formatter: Helper.dateFormatter)")
                
                // Paid date
                HStack {
                    Text(expense.isPaid ? "Expense Completed:" : "Expense Status:")
                    
                    Text(expense.paidDate != nil && expense.isPaid ? "\(expense.paidDate!, formatter: Helper.dateFormatter)" : "Outstanding")
                }
                Divider()
            }
            
            // Receipt picture
            if let image = expense.receiptPhoto {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        showingImageFullscreen = true
                    }
            }
            
            Spacer()
            
            // Checkbox for marking expense as paid
            HStack {
                Text("Mark as Paid:")
                
                CheckboxView(isChecked: $expense.isPaid)
                    .onTapGesture {
                        // Toggle the isChecked property of the checkbox
                        expense.isPaid.toggle()
                    }
                    .contentShape(Rectangle())
            }
            Spacer()
        }
        .padding( .horizontal)
        // Present fullscreen image when showingImageFullscreen is true
        .sheet(isPresented: $showingImageFullscreen) {
            FullscreenReceiptView(isImageFullscreen: $showingImageFullscreen, inputImage: expense.receiptPhoto)
        }
        // Present expense edit view when showingEditScreen is true
        .sheet(isPresented: $showingEditScreen) {
            ExpenseEditView(expense: expense)
        }
        // Update paidDate when isPaid changes
        .onChange(of: expense.isPaid) { _ in
            if expense.isPaid {
                expense.paidDate = Date()
            } else {
                expense.paidDate = nil
            }
        }
        // Save data when app becomes inactive
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

#Preview {
    ExpenseDetailView(expense: Expense(expenseSummary: "Fuel to work",
                                       totalAmount: 12.99,
                                       isPaid: false,
                                       includeVAT: true,
                                       incurredDate: Date.init(),
                                       addedDate: Date.init(),
                                       paidDate: Date()),
                      saveAction: {})
}

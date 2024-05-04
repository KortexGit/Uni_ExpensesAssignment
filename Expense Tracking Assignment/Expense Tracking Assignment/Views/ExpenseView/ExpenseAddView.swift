//
//  addExpenseView.swift
//  Assessment 2-3
//
//  Created by Connor Moloney on 25/02/2024.
//

import SwiftUI

struct ExpenseAddView: View {
    // Observed object to track changes in expenses list
    @ObservedObject var expensesList: Expenses
    // State object to manage new expense creation
    @StateObject var newExpense = Expense(expenseSummary: "", totalAmount: 0, isPaid: false, includeVAT: Bool(), incurredDate: Date(), addedDate: Date.init(), paidDate: nil)
    
    // State variables for handling image selection
    @State var image: Image?
    @State var inputImage: UIImage?
    @State private var showingImagePicker: Bool = false
    @State private var showingImageFullscreen: Bool = false
    // State variable to store string version for total amount
    @State private var totalAmountString: String = ""
    
    var body: some View {
        VStack (spacing: 20) {
            // Header row
            // Pass save action to closure
            HeaderRowView(saveAction: saveExpense, buttonState: .save)
                .padding( .top)
            
            Spacer()
            
            //            DataEntryView(expense: $newExpense, totalAmountString: $totalAmountString, image: $image, inputImage: $inputImage, showingImagePicker: $showingImagePicker, showingImageFullscreen: $showingImageFullscreen)
            //        }
            
            // Added date
            HStack {
                Text("Date: \(newExpense.addedDate, formatter: Helper.dateFormatter)")
                
                Spacer()
                // Toggle for including VAT
                Toggle(isOn: $newExpense.includeVAT) {
                    Text("VAT")
                }
                .frame(width: 90)
            }
            
            Divider()
            
            // Expense Summary
            HStack {
                Text("Expense Summary:")
                TextField("e.g. Fuel to work", text: $newExpense.expenseSummary)
                    .textFieldStyle( .roundedBorder)
            }
            
            // Total Amount with VAT Controls
            VStack {
                Divider()
                
                VStack {
                    Text("Amount: (Example: £12.99)")
                        .padding( .bottom, 8)
                    
                    TextField("£123.45", text: $totalAmountString)
                        .keyboardType( .decimalPad)
                        .multilineTextAlignment(.center)
                    
                    Divider()
                }
                
                // Display total amount with or without VAT based on user selection, uses a ternary conditional operator
                newExpense.includeVAT ?
                VStack (spacing: 8) {
                    Text("Amount (exc VAT): £\(String(format: "%.2f", newExpense.totalAmount))")
                    Text("Amount (inc VAT): £\(newExpense.totalAmountIncludingVAT)") // Already formatted to 2SF when VAT added
                }
                :
                VStack {
                    Text("Amount (exc VAT): £\(String(format: "%.2f", newExpense.totalAmount))")
                    Text("")
                }
                
                Divider()
            }
            
            // Dates
            VStack (spacing: 8) {
                // Incurred date
                DatePicker("Date Incurred:", selection: $newExpense.incurredDate, displayedComponents: [ .date])
                    .frame(width: 240)
                
                // Paid date
                Text("Expense Status: Outstanding")
                
                Divider()
            }
            
            // Photo picker
            VStack {
                // Display selected image
                image?
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        // Activates the state variable to show fullscreen image
                        showingImageFullscreen = true
                    }
                
                // Placeholder for selecting receipt photo
                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .fill( .blue)
                        .frame(width: 300, height: 50)
                    
                    Text("Tap to select receipt photo")
                        .foregroundColor( .white)
                        .font( .headline)
                }
                .onTapGesture {
                    // Activates the state variable to show image picker
                    showingImagePicker = true
                }
                
                Spacer()
            }
        }
        .padding( .horizontal)
        // Load image when inputImage changes
        .onChange(of: inputImage) { _ in
            Helper.loadImage(inputImage: inputImage, targetImage: $image)
            newExpense.receiptPhoto = inputImage
        }
        // Update totalAmount in newExpense when totalAmountString changes
        .onChange(of: totalAmountString) { _ in newExpense.totalAmount = Double(totalAmountString) ?? 0.00}
        // Present image picker when showingImagePicker is true
        .sheet(isPresented: $showingImagePicker)
        {
            ImagePicker(image: $inputImage)
        }
        // Present fullscreen image when showingImageFullscreen is true
        .sheet(isPresented: $showingImageFullscreen) {
            FullscreenReceiptView(isImageFullscreen: $showingImageFullscreen, inputImage: inputImage)
        }
    }
    
    // Function to save new expense
    private func saveExpense() {
        DispatchQueue.main.async {
            newExpense.tempExpenseSummary = newExpense.expenseSummary
            // Convert the string representation of total amount to double before saving
            if let amount = Double(totalAmountString) {
                newExpense.totalAmount = amount
                newExpense.tempTotalAmount = amount
            }
            // Append the new Expense to expensesList
            expensesList.expenses.append(newExpense)
            //saveAction()
        }
    }
}

#Preview {
    ExpenseAddView(expensesList: Expenses())
}


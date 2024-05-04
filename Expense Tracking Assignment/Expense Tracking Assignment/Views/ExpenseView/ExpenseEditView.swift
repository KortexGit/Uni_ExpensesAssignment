//
//  ExpenseEditView.swift
//  Assessment 2-3
//
//  Created by Connor Moloney on 08/03/2024.
//

import SwiftUI

struct ExpenseEditView: View {
    // State object to manage the expense being edited
    @StateObject var expense: Expense // TODO: Was state before
    
    // State variables for handling image selection
    @State var image: Image?
    @State var inputImage: UIImage?
    
    // State variables to control which sheet is presenting
    @State private var showingImagePicker: Bool = false
    @State private var showingImageFullscreen: Bool = false
    
    // State variable to hold total amount string value
    @State private var totalAmountString: String = ""
    
    var body: some View {
        VStack (spacing: 20) {
            // Header row
            HeaderRowView(saveAction: updateExpense, buttonState: .update)
                .padding( .top)
            
            Spacer()
            
            //            // Data input View
            //            DataEntryView(expense: $expense, totalAmountString: $totalAmountString, image: $image, inputImage: $inputImage, showingImagePicker: $showingImagePicker, showingImageFullscreen: $showingImageFullscreen)
            
            // Added date
            HStack {
                Text("Date: \(expense.addedDate, formatter: Helper.dateFormatter)")
                
                Spacer()
                
                // Toggle for including VAT
                Toggle(isOn: $expense.includeVAT) {
                    Text("VAT")
                }
                .frame(width: 90)
            }
            
            Divider()
            
            // Expense Summary
            HStack {
                Text("Expense Summary:")
                TextField("e.g. Fuel to work", text: $expense.tempExpenseSummary)
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
                
                expense.includeVAT ?
                VStack (spacing: 8) {
                    Text("Amount (exc VAT): £\(String(format: "%.2f", expense.tempTotalAmount))")
                    Text("Amount (inc VAT): £\(expense.totalAmountIncludingVAT)") // Already formatted to 2SF when VAT is added
                }
                :
                VStack {
                    Text("Amount (exc VAT): £\(String(format: "%.2f", expense.tempTotalAmount))")
                    Text("")
                }
                
                Divider()
            }
            
            // Dates
            VStack (spacing: 8) {
                // Incurred date
                DatePicker("Date Incurred:", selection: $expense.incurredDate, displayedComponents: [ .date])
                    .frame(width: 240)
                
                // Paid date
                HStack {
                    // If isPaid is true displays Expense Completed otherwise shows Expense Status
                    Text(expense.isPaid ? "Expense Completed:" : "Expense Status:")
                    
                    // If paidDate is not nil will force unwrap paidDate otherwise will show Ouutstanding
                    Text(expense.paidDate != nil && expense.isPaid ? "\(expense.paidDate!, formatter: Helper.dateFormatter)" : "Outstanding")
                }
                
                Divider()
            }
            
            // Photo picker
            VStack {
                // Receipt picture
                image?
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        showingImageFullscreen = true
                    }
                
                ZStack {
                    // Receipt Photo Picker
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .fill( .blue)
                        .frame(width: 300, height: 50)
                    
                    Text("Tap to select receipt photo")
                        .foregroundColor( .white)
                        .font( .headline)
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                Spacer()
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
        }
        .padding( .horizontal)
        // Load image when inputImage changes
        .onChange(of: inputImage) { _ in Helper.loadImage(inputImage: inputImage, targetImage: $image) }
        // Load initial values for the view
        .onAppear {
            image = Image(uiImage: expense.receiptPhoto ?? UIImage())
            expense.tempReceiptPhoto = expense.receiptPhoto
            totalAmountString = String(expense.totalAmount)
        }
        // Reset temporary values when view disappears
        .onDisappear {
            // Change variables back to initial values
            expense.tempExpenseSummary = expense.expenseSummary
            expense.tempTotalAmount = expense.totalAmount
            expense.tempReceiptPhoto = expense.receiptPhoto
            totalAmountString = ""
        }
        // Present image picker
        .sheet(isPresented: $showingImagePicker)
        {
            ImagePicker(image: $inputImage)
        }
        // Present fullscreen image
        .sheet(isPresented: $showingImageFullscreen) {
            FullscreenReceiptView(isImageFullscreen: $showingImageFullscreen, inputImage: expense.tempReceiptPhoto)
        }
    }
    
    // Function to update expense
    private func updateExpense() {
        DispatchQueue.main.async {
            // Update expense details
            expense.expenseSummary = expense.tempExpenseSummary
            
            // Convert the string representation of total amount to double before saving
            if let amount = Double(totalAmountString) {
                expense.totalAmount = amount
                expense.tempTotalAmount = amount
            }
            
            expense.includeVAT = expense.includeVAT
            expense.isPaid = expense.isPaid
            expense.addedDate = expense.addedDate
            expense.incurredDate = expense.incurredDate
            expense.paidDate = expense.paidDate
            
            // Checks that inputImage is not nil before assigning to receiptPhoto for persistency
            if inputImage != nil {
                expense.receiptPhoto = inputImage
            }
        }
    }
}

#Preview {
    ExpenseEditView(expense: Expense(expenseSummary: "", totalAmount: 19.99, isPaid: false, includeVAT: false, incurredDate: Date.init(), addedDate: Date.init(), paidDate: nil))
}

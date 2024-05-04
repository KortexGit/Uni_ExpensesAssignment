//
//  DataEntryView.swift
//  Assessment 2-3
//
//  Created by Connor Moloney on 04/03/2024.
//

import SwiftUI

struct DataEntryView: View {
    @StateObject var expense: Expense
    @Binding var totalAmountString: String
    @Binding var image: Image?
    @Binding var inputImage: UIImage?
    @Binding var showingImagePicker: Bool
    @Binding var showingImageFullscreen: Bool

    var body: some View {
        VStack(spacing: 20) {
            // Added date
            HStack {
                Text("Date: \(expense.addedDate, formatter: Helper.dateFormatter)")
                Spacer()
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
                    .textFieldStyle(.roundedBorder)
            }
            
            // Total Amount with VAT Controls
            VStack {
                Divider()
                VStack {
                    Text("Amount: (Example: £12.99)")
                        .padding(.bottom, 8)
                    TextField("£123.45", text: $totalAmountString)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                    Divider()
                }
                
                expense.includeVAT ?
                VStack(spacing: 8) {
                    Text("Amount (exc VAT): £\(String(format: "%.2f", expense.tempTotalAmount))")
                    Text("Amount (inc VAT): £\(expense.totalAmountIncludingVAT)")
                } :
                VStack {
                    Text("Amount (exc VAT): £\(String(format: "%.2f", expense.tempTotalAmount))")
                    Text("")
                }
                Divider()
            }
            
            // Dates
            VStack(spacing: 8) {
                DatePicker("Date Incurred:", selection: $expense.incurredDate, displayedComponents: [.date])
                    .frame(width: 240)
                
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
                        showingImageFullscreen = true
                    }
                
                // Placeholder for selecting receipt photo
                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .fill(.blue)
                        .frame(width: 300, height: 50)
                    Text("Tap to select receipt photo")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                Spacer()
            }
        }
    }
}

//#Preview {
//    DataEntryView(expense: $Expense(), totalAmountString: "", image: Image(), inputImage: Image(), showingImagePicker: Bool(), showingImageFullscreen: Bool())
//}

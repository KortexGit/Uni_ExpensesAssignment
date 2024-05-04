//
//  Expense.swift
//  Assessment 2-3
//
//  Created by Connor Moloney on 25/02/2024.
//

import Foundation
import SwiftUI

class Expense: Identifiable, ObservableObject, Codable, Equatable {
    // Published properties for tracking changes and updating views
    @Published var expenseSummary: String
    @Published var totalAmount: Double
    @Published var isPaid: Bool
    @Published var includeVAT: Bool
    @Published var incurredDate: Date
    @Published var addedDate: Date
    @Published var paidDate: Date?
    @Published var receiptPhoto: UIImage?
    
    // Temporary properties to store new values before they are saved
    var tempExpenseSummary: String
    var tempTotalAmount: Double // TODO: Change to double
    @Published var tempReceiptPhoto: UIImage?
    
    // Unique identifier for each expense
    let id = UUID()
    
    // Initialise an expense object with provided data
    init(expenseSummary: String, totalAmount: Double, isPaid: Bool, includeVAT: Bool, incurredDate: Date, addedDate: Date, paidDate: Date?) {
        
        self.expenseSummary = expenseSummary
        self.totalAmount = totalAmount
        self.isPaid = isPaid
        self.includeVAT = includeVAT
        self.incurredDate = incurredDate
        self.addedDate = addedDate
        self.paidDate = paidDate
        
        self.tempExpenseSummary = expenseSummary
        self.tempTotalAmount = totalAmount
        self.tempReceiptPhoto = receiptPhoto
    }
    
    // Coding keys for encoding and decoding
    enum CodingKeys: CodingKey {
        case expenseSummary, totalAmount, isPaid, includeVAT, incurredDate, addedDate, paidDate, receiptPhoto, id
    }
    
    // Encode the expense object to JSON
    func encode(to encoder: Encoder) throws {
        writeReceiptPhotoToDisk()
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(expenseSummary, forKey: .expenseSummary)
        try container.encode(totalAmount, forKey: .totalAmount)
        try container.encode(isPaid, forKey: .isPaid)
        try container.encode(includeVAT, forKey: .includeVAT)
        try container.encode(incurredDate, forKey: .incurredDate)
        try container.encode(addedDate, forKey: .addedDate)
        try container.encodeIfPresent(paidDate, forKey: .paidDate)
    }
    
    // Initialise an object by decoding from JSON
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let decodedExpenseSummary = try container.decode(String.self, forKey: .expenseSummary)
        let decodedTotalAmount = try container.decode(Double.self, forKey: .totalAmount) // TODO: Change type to Double
        let decodedIsPaid = try container.decode(Bool.self, forKey: .isPaid)
        let decodedIncludeVAT = try container.decode(Bool.self, forKey: .includeVAT)
        let decodedIncurredDate = try container.decode(Date.self, forKey: .incurredDate)
        let decodedAddedDate = try container.decode(Date.self, forKey: .addedDate)
        let decodedPaidDate = try container.decodeIfPresent(Date.self, forKey: .paidDate)
        
        expenseSummary = decodedExpenseSummary
        totalAmount = decodedTotalAmount
        isPaid = decodedIsPaid
        includeVAT = decodedIncludeVAT
        incurredDate = decodedIncurredDate
        addedDate = decodedAddedDate
        paidDate = decodedPaidDate
        
        tempExpenseSummary = decodedExpenseSummary
        tempTotalAmount = decodedTotalAmount
        
        // Load receipt photo from disk if available
        let receiptPhotoPath = try? FileManager.default.url(for: .documentDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create:false)
            .appendingPathComponent("\(expenseSummary).jpg") // expense summary previously
        
        if let loadPath = receiptPhotoPath {
            if let data = try? Data(contentsOf: loadPath) {
                self.receiptPhoto = UIImage(data: data)
            }
        }
    }
    
    // Calculate the total amount including VAT
    var totalAmountIncludingVAT: String {
        let totalWithVAT = totalAmount * 1.20 // Add 20% VAT
        return String(format: "%.2f", totalWithVAT)
    }
    
    // Function to compress and write the receipt photo to device storage
    func writeReceiptPhotoToDisk() {
        if let receiptPhotoToSave = self.receiptPhoto {
            let imagePath = try? FileManager.default.url(for: .documentDirectory,
                                                         in: .userDomainMask,
                                                         appropriateFor: nil,
                                                         create:false)
                .appendingPathComponent("\(expenseSummary).jpg")
            
            if let jpegData = receiptPhotoToSave.jpegData(compressionQuality: 0.9) {
                if let savePath = imagePath {
                    try? jpegData.write(to: savePath,
                                        options: [.atomic, .completeFileProtection])
                }
            }
        }
    }
    
    // Equatable implementation for comparing expenses
    static func == (lhs: Expense, rhs: Expense) -> Bool {
        return lhs.id == rhs.id
    }
}

//
//  DateFormatter.swift
//  Assessment 2-3
//
//  Created by Connor Moloney on 05/03/2024.
//

import Foundation
import SwiftUI

struct Helper {
    // DateFormatter for formatting dates in a long style without time
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // NumberFormatter for formatting currency with pound sterling symbol
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "£"
        return formatter
    }()
    
    // Function to load UIImage into SwiftUI Image
    static func loadImage(inputImage: UIImage?, targetImage: Binding<Image?>) {
        // If inputImage is nil, return a placeholder image
        guard let inputImage = inputImage else { return }
        // Sets targetImage to inputImage and accesses underlying value as its a binding value
        targetImage.wrappedValue = Image(uiImage: inputImage)
    }
}

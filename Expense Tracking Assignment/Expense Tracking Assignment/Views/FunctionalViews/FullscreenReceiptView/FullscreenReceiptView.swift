//
//  FullscreenReceiptView.swift
//  Assessment 2-3
//
//  Created by Connor Moloney on 08/03/2024.
//

import SwiftUI

struct FullscreenReceiptView: View {
    // Binding to control the visibility of the fullscreen image view
    @Binding var isImageFullscreen: Bool
    
    // UIImage property representing the input image to be displayed fullscreen
    var inputImage: UIImage?
    
    var body: some View {
        // Check if inputImage is not nil
        if let inputImage = inputImage {
            VStack {
                // Header row with a dismiss button to close the fullscreen view
                HStack {
                    Button {
                        // Set isImageFullscreen to false to dismiss the fullscreen view
                        isImageFullscreen = false
                    } label: {
                        Text("Dismiss")
                    }
                    .padding(.top, 15)
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Spacer()
                }
                
                Spacer()
                
                // Display the input image with resizable and aspect ratio fit modifiers
                Image(uiImage: inputImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    FullscreenReceiptView(isImageFullscreen: Binding.constant(true))
}

//
//  CameraView.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/27.
//

import SwiftUI

struct LiveTextFromCameraScan: View {
    @Environment(\.dismiss) var dismiss
    @Binding var liveScan: Bool
    @Binding var scannedText: String
    var body: some View {
        NavigationStack {
            VStack {
                DataScannerVC(scannedText: $scannedText, liveScan: $liveScan)
                Text("Tap screen to see the results!")
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Capture Text")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct LiveTextFromCameraScan_Previews: PreviewProvider {
    static var previews: some View {
        LiveTextFromCameraScan(liveScan: .constant(false), scannedText: .constant(""))
    }
}

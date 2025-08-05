//
//  ScannerView.swift
//  Barcode-Scanner
//
//  Created by Kyle Morton on 8/4/25.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    
    @Binding var scannedCode: String

    func makeUIViewController(context: Context) -> ScannerVC {
        ScannerVC(scannerDelete: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: ScannerVC, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(scannerView: self) // pass in self here so the coordinator can update our binding for us
    }
    
    // this allows UIKit to tell our coordinate what happened, then we can use it in SwiftUI
    // Coordinator is your middle man to relay when something happens in UIKit w/ the camera
    final class Coordinator : NSObject, ScannerVCDelegate {
        
        private let scannerView: ScannerView
        
        init(scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        
        // here's our listeners for barcode and our error
        func didFind(barcode: String) {
            scannerView.scannedCode = barcode
            print(barcode)
        }
        
        func didSurface(error: CameraError) {
            print(error.rawValue)
        }
        
        
    }
}

#Preview {
    ScannerView(scannedCode: .constant(""))
}

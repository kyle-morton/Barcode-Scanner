//
//  BarcodeScannerViewModel.swift
//  Barcode-Scanner
//
//  Created by Kyle Morton on 8/6/25.
//

import SwiftUI

final class BarBarcodeScannerViewModel: ObservableObject {
    
    // remember these are publishing their changes out to whoever is listening (hence publish)
    @Published public var scannedCode = ""
    @Published public var alertItem: AlertItem?
    
    
    // Computed properties (helpers/extensions)
    // return not needed w/ only 1 line of code (new in swift 5.1)
    var statusText: String {
        scannedCode.isEmpty ? "Not yet scanned" : scannedCode
    }
    
    var statusTextColor: Color {
        scannedCode.isEmpty ? .red : .green
    }
}


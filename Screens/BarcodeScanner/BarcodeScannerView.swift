//
//  ContentView.swift
//  Barcode-Scanner
//
//  Created by Kyle Morton on 8/4/25.
//

import SwiftUI


struct BarcodeScannerView: View {
    
    
    // New VM -> StateObject, Passed VM -> ObservedObject
    @StateObject private var scannerViewModel = BarBarcodeScannerViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                
                ScannerView(scannedCode: $scannerViewModel.scannedCode, alertItem: $scannerViewModel.alertItem)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                
                Spacer()
                    .frame(height:60)
                
                Label("Scanned Barcode", systemImage: "barcode.viewfinder")
                    .font(.title)
                
                Text(scannerViewModel.statusText)
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(scannerViewModel.statusTextColor)
                    .padding()
                
            }
            .navigationTitle("Barcode Scanner")
            .alert(item: $scannerViewModel.alertItem) { item in // if have an alert, show it
                Alert(
                    title: Text(item.title),
                    message: Text(item.message),
                    dismissButton: item.dismissButton
                )
            }
        }
    }
}

#Preview {
    BarcodeScannerView()
}

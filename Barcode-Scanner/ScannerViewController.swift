//
//  ScannerViewController.swift
//  Barcode-Scanner
//
//  Created by Kyle Morton on 8/4/25.
//

import Foundation
import AVFoundation
import UIKit

enum CameraError: String {
    case invalidDeviceInput     = "Something is wrong with the camera. We are unable to capture the input."
    case InvalidScanValue       = "The value scanned is not valid. This app scans EAN-8 and EAN-13 barcodes."
}

protocol ScannerVCDelegate: AnyObject {
    func didFind(barcode: String) // when you find a barcode, send it up to your delegate
    func didSurface(error: CameraError)
}

final class ScannerVC: UIViewController {
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerDelete: ScannerVCDelegate! // weak here keeps us from hitting a memory leak
    
    init(scannerDelete: ScannerVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.scannerDelete = scannerDelete
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // only required for storyboard (not using it)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer = previewLayer else {
            scannerDelete?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        previewLayer.frame = view.layer.bounds
    }
    
    private func setupCaptureSession() {
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            scannerDelete.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
            
        }catch {
            scannerDelete.didSurface(error: .invalidDeviceInput)
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        else {
            scannerDelete.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13] // telling camera to look for both barcode types (can do qr codes and other things too)
        }
        else {
            scannerDelete.didSurface(error: .invalidDeviceInput)
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill // fill the view we tell you, but keep the aspect ratio
        view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
    }
    
    
    
}


extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
            scannerDelete.didSurface(error: .InvalidScanValue)
            return
        }
        
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelete.didSurface(error: .InvalidScanValue)
            return
        }
        
        // we're digging thru the data here to get the barcode string that we want
        
        guard let barcode = machineReadableObject.stringValue else {
            scannerDelete.didSurface(error: .InvalidScanValue)
            return
        }
        
        // we found it, return our barcode to the delegate
//        captureSession.stopRunning(); // only do this if you want to restart the camera view w/ a restart button
        scannerDelete.didFind(barcode: barcode)
    }
}

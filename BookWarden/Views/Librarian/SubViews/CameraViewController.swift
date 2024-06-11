//
//  CameraViewController.swift
//  BookWarden
//
//  Created by ASHU SINGHAL on 11/06/24.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var qrCodeAlert: Binding<Bool>
    var qrCodeString: Binding<String?>

    init(qrCodeAlert: Binding<Bool>, qrCodeString: Binding<String?>) {
        self.qrCodeAlert = qrCodeAlert
        self.qrCodeString = qrCodeString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()

        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession?.addInput(input)
        } catch {
            print("Error getting camera input")
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession?.canAddOutput(metadataOutput) == true {
            captureSession?.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            print("Could not add metadata output")
            return
        }

        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)

        captureSession?.startRunning()

        qrCodeFrameView = UIView()
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession?.stopRunning()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)

            if let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: readableObject) {
                qrCodeFrameView?.frame = barCodeObject.bounds
            }
        }
    }

    func found(code: String) {
        print("QR Code: \(code)")
        qrCodeString.wrappedValue = code
        qrCodeAlert.wrappedValue = true
        
        // Dismiss the view controller or do any additional handling here
        self.dismiss(animated: true, completion: nil)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    @Binding var qrCodeAlert: Bool
    @Binding var qrCodeString: String?

    func makeUIViewController(context: Context) -> CameraViewController {
        return CameraViewController(qrCodeAlert: $qrCodeAlert, qrCodeString: $qrCodeString)
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

import SwiftUI
import AVFoundation

struct QRScannerView: View {
    @State private var isShowingScanner = false
    @State private var scannedCode: String?

    var body: some View {
        NavigationView {
            VStack {
                if let scannedCode = scannedCode {
                    Text("Scanned Code: \(scannedCode)")
                        .padding()
                } else {
                    Text("No code scanned yet.")
                        .padding()
                }

                Button(action: {
                    isShowingScanner = true
                }) {
                    Image(systemName: "qrcode.viewfinder")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding()
                }
            }
            .navigationBarTitle("Barcode Scanner")
            .sheet(isPresented: $isShowingScanner) {
                BarcodeScannerView { code in
                    self.scannedCode = code
                    self.isShowingScanner = false
                }
            }
        }
    }
}

struct BarcodeScannerView: UIViewControllerRepresentable {
    var didFindCode: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return viewController
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return viewController
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .qr]
        } else {
            return viewController
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)

        captureSession.startRunning()

        context.coordinator.captureSession = captureSession

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: Coordinator) {
        coordinator.captureSession?.stopRunning()
    }

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: BarcodeScannerView
        var captureSession: AVCaptureSession?

        init(parent: BarcodeScannerView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                parent.didFindCode(stringValue)
            }
        }
    }
}

//@main
//struct BarcodeScannerApp: App {
//    var body: some Scene {
//        WindowGroup {
//            MainView()
//        }
//    }
//}

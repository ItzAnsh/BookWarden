//import SwiftUI
//import AVFoundation
//
////QRScannerView(ISBNCode: $ISBN, ISBN10: $ISBN10, ISBN13: $ISBN13, bookName: $bookName, bookAuthor: $bookAuthor, genre: $genre, publisher: $publisher, length: $length)
//struct QRScannerView: View {
//    @State private var isShowingScanner = false
//    @State private var scannedCode: String?
//    @Binding var ISBNCode: String
//    @Binding var ISBN10: String
//    @Binding var ISBN13: String
//    @Binding var bookName: String
//    @Binding var bookAuthor: String
//    @Binding var genre: String
//    @Binding var publisher: String
//    @Binding var length: String
//    
//    var bookManager = BookManager.shared
//    
//    var body: some View {
//        
//        VStack() {
//            Image(systemName: "barcode.viewfinder")
//                .foregroundColor(.blue)
//                .font(.system(size: 80))
//        }
//        .frame(maxWidth: .infinity)
//        .background(Color(.systemGray6)) // Set background to systemGray6
//        .onTapGesture {
//            isShowingScanner = true
//        }
//        
//        .navigationBarTitle("Barcode Scanner")
//        .sheet(isPresented: $isShowingScanner) {
//            BarcodeScannerView { code in
//                self.scannedCode = code
//                self.isShowingScanner = false
//                self.ISBNCode = code.count == 13 || code.count == 10 ? code : ""
//                if code.count == 10 {
//                    ISBN10 = code
//                }
//                
//                if code.count == 13 {
//                    ISBN13 = code
//                }
//                
//                bookManager.fetchBookThroughISBN(code: "9780099549482") { result in
//                    switch result {
//                    case .success(let book):
//                        print(book)
//                        bookName = book.title
//                        bookAuthor = book.author
//                    case .failure(let error):
//                        print("Failed to fetch book: \(error)")
//                    }
//                }
//            }
//        }
//        
//    }
//}
//
//struct BarcodeScannerView: UIViewControllerRepresentable {
//    var didFindCode: (String) -> Void
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(parent: self)
//    }
//    
//    func makeUIViewController(context: Context) -> UIViewController {
//        let viewController = UIViewController()
//        let captureSession = AVCaptureSession()
//        
//        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }
//        let videoInput: AVCaptureDeviceInput
//        
//        do {
//            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
//        } catch {
//            return viewController
//        }
//        
//        if captureSession.canAddInput(videoInput) {
//            captureSession.addInput(videoInput)
//        } else {
//            return viewController
//        }
//        
//        let metadataOutput = AVCaptureMetadataOutput()
//        
//        if captureSession.canAddOutput(metadataOutput) {
//            captureSession.addOutput(metadataOutput)
//            
//            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
//            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .qr]
//        } else {
//            return viewController
//        }
//        
//        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        previewLayer.frame = viewController.view.layer.bounds
//        previewLayer.videoGravity = .resizeAspectFill
//        viewController.view.layer.addSublayer(previewLayer)
//        
//        captureSession.startRunning()
//        
//        context.coordinator.captureSession = captureSession
//        
//        return viewController
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//    
//    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: Coordinator) {
//        coordinator.captureSession?.stopRunning()
//    }
//    
//    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
//        var parent: BarcodeScannerView
//        var captureSession: AVCaptureSession?
//        
//        init(parent: BarcodeScannerView) {
//            self.parent = parent
//        }
//        
//        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//            if let metadataObject = metadataObjects.first {
//                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
//                guard let stringValue = readableObject.stringValue else { return }
//                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//                parent.didFindCode(stringValue)
//            }
//        }
//    }
//}
//
////@main
////struct BarcodeScannerApp: App {
////    var body: some Scene {
////        WindowGroup {
////            MainView()
////        }
////    }
////}

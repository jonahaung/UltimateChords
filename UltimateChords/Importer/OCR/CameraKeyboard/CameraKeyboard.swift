//
//  CameraKeyboard.swift
//  Live Text Address
//
//  Created by Jackson Chung on 2/8/2021.
//

import AVFoundation
import UIKit
import Vision

class CameraKeyboard: UIView {
    
    weak var textView: UITextView?
    
    private var captureSession: AVCaptureSession?
    
    private var regionOfInterest = CGRect(x: 0.02, y: 0.83, width: 0.96, height: 0.15)
    private let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
    private let tracker: ObjectTracker<String> = .init()
    private var isDragging = false
    private var isStabled = false {
        didSet {
            guard oldValue != isStabled else { return }
            textLayer.strokeColor = isStabled ? UIColor.systemGreen.cgColor : UIColor.systemOrange.cgColor
        }
    }
    
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private let regionView: UIView = {
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
        return $0
    }(UIView())
    
    private let textLayer: CAShapeLayer = {
        $0.lineWidth = 1
        $0.strokeColor = UIColor.systemOrange.cgColor
        $0.fillColor = nil
        return $0
    }(CAShapeLayer())
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        observeKeyboard()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(pan)
    }
    
    deinit {
        unObserveKeyboard()
        stopCamera()
        print("Camera Keyboard")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
        guard !isDragging else { return }
        let scaleT = CGAffineTransform(scaleX: frame.width, y: -frame.height)
        let translateT = CGAffineTransform(translationX: 0, y: frame.height)
        let transform = scaleT.concatenating(translateT)
        let rect = regionOfInterest.applying(transform)
        regionView.frame = rect
        textLayer.frame = regionView.bounds
    }
    
    
}
// Touches
extension CameraKeyboard {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if touches.count > 0 && !isDragging {
            
            videoQueue.async { [weak self] in
                guard let self = self else { return }
                self.captureSession?.stopRunning()
                
                DispatchQueue.main.async {
                    self.resetStable()
                    if let textView = self.textView, let range = textView.markedTextRange, let markedText = textView.text(in: range) {
                        textView.insertText(markedText.newLine)
                    }
                                            
                    self.videoQueue.async { [weak self] in
                        guard let self = self else { return }
                        self.captureSession?.startRunning()
                    }
                }
            }
        }
    }
    
    @objc private func handlePan(_ gestur: UIPanGestureRecognizer) {
        switch gestur.state {
        case .began:
            isDragging = true
            textLayer.path = nil
        case .changed:
            textLayer.path = nil
            let translation = gestur.translation(in: self)
            let height = min(bounds.height - regionView.frame.minY*4, max(20, (regionView.frame.size.height + translation.y / 20)))
            let width = min(bounds.width - regionView.frame.minX*2, max(20, (regionView.frame.size.width + translation.x / 20)))
            regionView.frame.size = CGSize(width: width, height: height)
        case .ended:
            updateRegionOfInterest()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self = self else { return }
                self.isDragging = false
            }
        default:
            updateRegionOfInterest()
            isDragging = false
        }
    }
    
    private func updateRegionOfInterest() {
        let scaleT = CGAffineTransform(scaleX: frame.width, y: -frame.height)
        let translateT = CGAffineTransform(translationX: 0, y: frame.height)
        let transform = scaleT.concatenating(translateT)
        regionOfInterest = regionView.frame.applying(transform.inverted())
    }
}
// Vision

extension CameraKeyboard {
    // MARK: text recognition
    private func detectText(buffer: CVPixelBuffer) {
        
        let request = VNRecognizeTextRequest(completionHandler: textRecognitionHandler)
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false
        request.regionOfInterest = regionOfInterest
        let requests = [request]
        let handler = VNImageRequestHandler(cvPixelBuffer: buffer, orientation: .up, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform(requests)
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    private func textRecognitionHandler(request: VNRequest, error: Error?) {
        
        guard let results = request.results as? [VNRecognizedTextObservation] else { return }
        guard results.isEmpty == false else {
            DispatchQueue.main.async {
                self.clearTexts()
            }
            return
        }
        
        var texts = [String]()
        
        results.forEach {
            if let top = $0.topCandidates(1).first {
                texts.append(top.string)
            }
        }
        let text = texts.joined(separator: " ")
        let originalText = texts.joined(separator: "\r")
        
        self.tracker.logFrame(objects: [text])
        self.isStabled = self.tracker.getStableItem() != nil
        DispatchQueue.main.async {
            self.displayTextBoxes(boxs: results)
            
            guard let textView = self.textView else { return }
            textView.setMarkedText(originalText, selectedRange: textView.selectedRange)
            
        }
    }
    
    private func displayTextBoxes(boxs: [VNRecognizedTextObservation]) {
        let frame = regionView.bounds
        let scaleT = CGAffineTransform(scaleX: frame.width, y: -frame.height)
        let translateT = CGAffineTransform(translationX: 0, y: frame.height)
        let transform = scaleT.concatenating(translateT)
        
        let path = UIBezierPath()
        boxs.forEach { box in
            let quad = Quadrilateral(rectangleObservation: box).applying(transform)
            path.append(quad.path)
        }
        
        textLayer.path = path.cgPath
    }
    
    private func clearTexts() {
        textLayer.path = nil
        textView?.setMarkedText(nil, selectedRange: .init())
        resetStable()
    }
    private func resetStable() {
        isStabled = false
        tracker.resetAll()
    }
}


// MARK: keyboard
extension CameraKeyboard {
    
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidHide(_:)),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
    }
    
    private func unObserveKeyboard() {
        NotificationCenter.default.removeObserver(self)
    }
    @objc private func keyboardWillShow(_ notification: UIKit.Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {
            return
        }
        // sync the view size with keyboard size
        frame = .init(origin: .zero, size: keyboardFrame.size)
    }
    
    @objc private func keyboardDidHide(_ notification: UIKit.Notification) {
        stopCamera()
    }
}


// MARK: Camera
extension CameraKeyboard {
    
    public func startCamera() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] response in
            guard let self = self else { return }
            if response {
                self.setupAndStartCaptureSession()
            } else {
                // TODO: ask for permission
            }
        }
    }
    func stopCamera() {
        previewLayer?.removeFromSuperlayer()
        captureSession?.stopRunning()
        
        previewLayer = nil
        captureSession = nil
        
    }
    
    private func setupAndStartCaptureSession() {
        if let captureSession = self.captureSession {
            print("capture session already exists")
            setupPreviewLayer(captureSession: captureSession)
            return
        }
        
        // start camera session will block the main thread, so we start in background thread
        DispatchQueue.global(qos: .userInitiated).async {
            let captureSession = AVCaptureSession()
            self.captureSession = captureSession
            captureSession.beginConfiguration()
            
            captureSession.sessionPreset = .medium // medium quality is good enough for text recognition
            self.setupCameraInput(captureSession: captureSession)
            self.setupOutput(captureSession: captureSession)
            
            captureSession.commitConfiguration()
            captureSession.startRunning()
            
            DispatchQueue.main.async {
                self.setupPreviewLayer(captureSession: captureSession)
            }
        }
    }
    
    private func setupCameraInput(captureSession: AVCaptureSession) {
        // use back camera only
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            //handle this appropriately for production purposes
            fatalError("no back camera")
        }
        
        guard let backInput = try? AVCaptureDeviceInput(device: device) else {
            fatalError("could not create input device from back camera")
        }
        
        guard captureSession.canAddInput(backInput) else {
            fatalError("could not add back camera input to capture session")
        }
        
        captureSession.addInput(backInput)
    }
    
    private func setupPreviewLayer(captureSession: AVCaptureSession) {
        guard previewLayer == nil else {
            print("preview layer already exists")
            return
        }
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resize
        self.previewLayer = previewLayer
        layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = bounds
        addSubview(regionView)
        regionView.layer.addSublayer(textLayer)
    }
    private func setupOutput(captureSession: AVCaptureSession) {
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if captureSession.canAddOutput(videoOutput) == true {
            captureSession.addOutput(videoOutput)
        } else {
            fatalError("could not add video output")
        }
        
        videoOutput.connections.first?.videoOrientation = .portrait
    }
}

extension CameraKeyboard: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return}
        detectText(buffer: cvBuffer)
    }
}

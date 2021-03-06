//
//  CameraView.swift
//  SwiftCamera
//
//  Created by Aung Ko Min on 5/4/22.
//

import SwiftUI


struct CameraView: View {
    
    @StateObject private var model = CameraViewModel()
    
    @Environment(\.dismiss) private var dismiss
    @Binding var item: PickedItem?
    
    @State private var currentZoomFactor: CGFloat = 1.0
    
    private var captureButton: some View {
        Button(action: {
            model.capturePhoto()
        }, label: {
            Circle()
                .foregroundColor(.white)
                .frame(width: 80, height: 80, alignment: .center)
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.8), lineWidth: 2)
                        .frame(width: 65, height: 65, alignment: .center)
                )
        })
    }
    
    private var flipCameraButton: some View {
        Button(action: {
            model.flipCamera()
        }, label: {
            Circle()
                .foregroundColor(Color.gray.opacity(0.2))
                .frame(width: 45, height: 45, alignment: .center)
                .overlay(Image(systemName: "camera.rotate.fill"))
        })
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack{
                        Button("Cancel") {
                            dismiss()
                        }
                        Spacer()
                        Button(action: {
                            model.switchFlash()
                        }, label: {
                            Image(systemName: model.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                                .font(.system(size: 20, weight: .medium, design: .default))
                        })
                    }.padding()
                    
                    
                    CameraPreview(session: model.session)
                        .gesture(
                            DragGesture().onChanged({ (val) in
                                //  Only accept vertical drag
                                if abs(val.translation.height) > abs(val.translation.width) {
                                    //  Get the percentage of vertical screen space covered by drag
                                    let percentage: CGFloat = -(val.translation.height / reader.size.height)
                                    //  Calculate new zoom factor
                                    let calc = currentZoomFactor + percentage
                                    //  Limit zoom factor to a maximum of 5x and a minimum of 1x
                                    let zoomFactor: CGFloat = min(max(calc, 1), 5)
                                    //  Store the newly calculated zoom factor
                                    currentZoomFactor = zoomFactor
                                    //  Sets the zoom factor to the capture device session
                                    model.zoom(with: zoomFactor)
                                }
                            })
                        )
                        .onAppear {
                            model.configure()
                        }
                        .alert(isPresented: $model.showAlertError, content: {
                            Alert(title: Text(model.alertError.title), message: Text(model.alertError.message), dismissButton: .default(Text(model.alertError.primaryButtonTitle), action: {
                                model.alertError.primaryAction?()
                            }))
                        })
                        .overlay(
                            Group {
                                if model.willCapturePhoto {
                                    Color.black
                                }
                            }
                        )
                    
                    HStack {
//                        flipCameraButton

                        Spacer()
                        
                        captureButton
                        
                        Spacer()
                        
//                        flipCameraButton
                    }
                    .padding(.horizontal, 20)
                }
            }.onChange(of: model.photo) { newValue in
                if let image = newValue?.image {
                    DispatchQueue.main.async {
                        self.item = .Image(image)
                        self.dismiss()
                    }
                }
                
            }
            .accentColor(.white)
        }
    }
}

//
//  ContentView.swift
//  Drawing
//
//  Created by Rafael Cabrera on 10/8/26.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    @State private var canvasView = PKCanvasView()
    @State private var toolPicker = PKToolPicker()
    
    var body: some View {
        NavigationView{
            VStack{
                CanvasView(canvasView: $canvasView, toolPicker: $toolPicker)
                    .navigationBarTitle("Drawing Apple Pencil App", displayMode: .inline)
                    .navigationBarItems(leading: HStack{
                        Button(action: clearCanvas){
                            Label("Clean", systemImage: "trash")
                        }.keyboardShortcut("t", modifiers: .command)
                    },
                                        trailing: HStack(spacing:10){
                        Button(action: undo) {
                            Label("Undo", systemImage: "arrow.uturn.backward")
                        }.keyboardShortcut("z", modifiers: .command)
                        Button(action: redo){
                            Label("Redo", systemImage: "arrow.uturn.forward")
                        }.keyboardShortcut("r", modifiers: .command)
                    }
                )
                    .onAppear(perform: setupToolPicker)
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func setupToolPicker(){
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }
    
    func clearCanvas(){
        canvasView.drawing = PKDrawing()
    }
    
    func undo() {
        canvasView.undoManager?.undo()
    }
    
    func redo() {
        canvasView.undoManager?.redo()
    }
}

struct CanvasView: UIViewRepresentable {
    
    @Binding var canvasView: PKCanvasView
    @Binding var toolPicker: PKToolPicker
    
    func makeUIView(context: Context) -> PKCanvasView {
        if #available(iOS 14.0, *){
            canvasView.drawingPolicy = .anyInput
        } else {
            canvasView.allowsFingerDrawing = true
        }
        canvasView.delegate = context.coordinator
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: CanvasView
        
        init(_ parent: CanvasView) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            
        }
    }
}

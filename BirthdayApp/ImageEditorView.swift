import SwiftUI

struct ImageEditorView: View {
    let originalImage: NSImage
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero

    var body: some View {
        GeometryReader { geo in
            Image(nsImage: originalImage)
                .resizable()
                .scaledToFit()
                .scaleEffect(scale)
                .offset(x: offset.width, y: offset.height)
                .gesture(DragGesture().onChanged { value in
                    offset = value.translation
                })
                .gesture(MagnificationGesture().onChanged { value in
                    scale = value
                })
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
        .frame(width: 300, height: 300)
        .padding()
    }
}

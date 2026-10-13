import Cocoa
import SwiftUI

class NotchPanel: NSPanel {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing bufferingType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: [.borderless, .nonactivatingPanel], backing: bufferingType, defer: flag)
        
        // Essential: Allows the panel to sit above the menu bar
        self.level = .screenSaver
        self.isOpaque = false
        self.hasShadow = false
        self.collectionBehavior = [.stationary, .canJoinAllSpaces, .fullScreenAuxiliary]
    }
}

// Usage in SwiftUI View

struct NotchView: View {
    @State private var isExpanded = false
    
    var body: some View {
        ZStack {
            Color.black // Background
            // Your content here
        }
        .frame(width: isExpanded ? 300 : 100, height: 40)
        .clipShape(NotchShape())
        .onHover { hovering in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isExpanded = hovering
            }
        }
    }
}

struct NotchShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        // Top center cutout (concave)
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width, y: height/2 + 10))
        path.addCurve(to: CGPoint(x: width/2, y: height/2 - 10),
                      control1: CGPoint(x: width, y: height/2),
                      control2: CGPoint(x: width/2 + 10, y: height/2))
        path.addCurve(to: CGPoint(x: 0, y: height/2 + 10),
                      control1: CGPoint(x: width/2 - 10, y: height/2),
                      control2: CGPoint(x: 0, y: height/2))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}

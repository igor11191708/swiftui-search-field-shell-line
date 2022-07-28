//
//  SearchFieldShellLine.swift
//  
//
//  Created by Igor Shelopaev on 28.07.2022.
//

import SwiftUI

/// Line with animation of lenght
///  Utility component for ``SearchFieldShell``
struct SearchFieldShellLine: Shape {
    
    /// Lines thickness
    private let lineHeight: CGFloat = 1
    
    /// Aminatable data
    var animatableData: Double {
        get { return x }
        set { x = newValue }
    }
    
    // MARK: - Config
        
    /// Available width size for component
    let width : Double
    
    /// Available height size for component
    let height: CGFloat
        
    /// Animatable variable for animatiing line length
    var x : Double = 0
    
    
    /// Create line for ``SearchFieldShell``
    /// - Parameter rect: Rect space
    /// - Returns: Line
    func path(in rect: CGRect) -> Path {
        let delta = self.height / 2
        let y = self.height
        return Path { path in
            path.move(to: CGPoint(x: width - delta, y: y))
            path.addLine(to: CGPoint(x: x, y: y))
        }
    }
}

#if DEBUG
struct SearchFieldShellLine_Previews: PreviewProvider {
    static var previews: some View {
        SearchFieldShellLine(width: .zero, height: 75, x: .zero)
    }
}
#endif

#if os(OSX)
    extension NSTextField {
        override open var focusRingType: NSFocusRingType {
            get { .none }
            set { }
        }
    }
#endif

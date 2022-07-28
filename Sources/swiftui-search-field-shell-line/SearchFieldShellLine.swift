//
//  SearchFieldShellLine.swift
//  
//
//  Created by Igor Shelopaev on 28.07.2022.
//

import SwiftUI

/// Line with animation of lenght
struct SearchFieldShellLine: Shape {
    
    /// Lines thickness
    private let lineHeight: CGFloat = 1
    
    
    /// Aminatable data
    var animatableData: Double {
        get { return x }
        set { x = newValue }
    }
    
    // MARK: - Config
    
    let width : Double
    
    let height: CGFloat
    
    var x : Double = 0

    
    func path(in rect: CGRect) -> Path {
        let delta = self.height / 2
        let y = self.height
        return Path { path in
            path.move(to: CGPoint(x: width - delta, y: y))
            path.addLine(to: CGPoint(x: x, y: y))
        }
    }
}

struct SearchFieldShellLine_Previews: PreviewProvider {
    static var previews: some View {
        SearchFieldShellLine(width: .zero, height: 75, x: .zero)
    }
}

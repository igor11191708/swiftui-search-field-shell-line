//
//  SearchFieldShell.swift
//
//
//  Created by Igor Shelopaev on 28.07.2022.
//

import SwiftUI

/// Search field with wrap and unwrap animation effect
public struct SearchFieldShell: View {

    /// Field focus management
    @FocusState private var fieldIsReady: Bool

    /// Trim factor for the circle
    @State private var trim: CGFloat = 1

    /// Lines thickness
    private let lineHeight: CGFloat = 1

    /// Trigger for scale animation
    @State private var animateScale: Bool = false

    /// Trigger for movement animation for lines
    @State private var animateLine: Bool = false

    /// Scale factor for start state
    private let startScale: CGFloat = 0.7

    /// Scale factor for end state
    private let endScale: CGFloat = 1.0

    private var animationTotal: CGFloat {
        durationScale + durationMove
    }

    @State var readyToEnter: Bool = false

    // MARK: - Config

    /// The height of the component
    let size: CGFloat

    /// Any icon name from SF symbols
    let imageName: String

    /// Lines color
    let color: Color

    /// Input text
    @Binding var text: String

    /// Duration of scale animation
    let durationScale: CGFloat

    /// Duration of movement animation
    let durationMove: CGFloat

    // MARK: - Life circle

    /// Initialization
    /// - Parameters:
    ///   - size: The height of the component
    ///   - color: Lines color
    ///   - imageName: Any icon name from SF symbols
    ///   - durationScale: Duration of scale animation
    ///   - durationMove: Duration of movement animation
    public init(
        text : Binding<String>,
        size: CGFloat = 75,
        color: Color = .blue,
        imageName: String = "magnifyingglass",
        durationScale: CGFloat = 0.5,
        durationMove: CGFloat = 1
    ) {
        self._text = text
        self.size = size
        self.color = color
        self.imageName = imageName
        self.durationScale = durationScale
        self.durationMove = durationMove
    }

    /// The content and behavior of the view
    public var body: some View {
        VStack {
            GeometryReader { proxy in
                let w = proxy.size.width
                shellTpl(w)
                HStack(alignment: .center) {
                    imageTpl(w)
                        .onTapGesture { routeAnimation() }
                    if readyToEnter {
                        textFieldTpl()
                    }
                }
                searchLine(proxy.size)
            }
        }.frame(height: size)
            .onChange(of: readyToEnter) { fieldIsReady = $0 }
    }

    // MARK: - Private

    /// Direct animation
    private func directAnimation() {
        withAnimation(.easeOut(duration: durationScale)) {
            animateScale.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + durationScale) {
                withAnimation(.easeInOut(duration: durationMove)) {
                    animateLine.toggle()
                    trim = 0
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + animationTotal) {
            readyToEnter = true
        }
    }

    /// Reverse animation
    private func reverseAnimation() {
        readyToEnter = false
        withAnimation(.easeOut(duration: durationMove)) {
            animateLine.toggle()
            trim = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + durationMove) {
                withAnimation(.easeInOut(duration: durationScale)) {
                    animateScale.toggle()
                }
            }
        }
    }

    /// Animation router
    private func routeAnimation() {
        if animateScale == false {
            directAnimation()
        } else {
            reverseAnimation()
        }
    }

    ///Text field template
    @ViewBuilder
    private func textFieldTpl() -> some View {
        if animateLine && animateScale {
            TextField("", text: $text)
                .padding(.trailing, size / 2)
                .font(.system(size: size * 0.75))
                .focused($fieldIsReady)
        }
    }

    /// Search line temple
    /// - Parameter size: Available size for component
    /// - Returns: View
    @ViewBuilder
    private func searchLine(_ size: CGSize) -> some View {
        let width = size.width
        let delta = self.size / 2
        let x = animateLine ? 0 + delta : width - delta
        SearchFieldShellLine(width: width, height: self.size, x: x)
            .stroke(lineWidth: lineHeight).stroke(color)
    }

    /// Icon template
    /// - Parameter width: Available width size for component
    /// - Returns: View
    @ViewBuilder
    private func imageTpl(_ width: CGFloat) -> some View {
        let image = Image(systemName: imageName)
            .resizable()
            .frame(width: size, height: size)
            .font(.system(size: size, weight: .light))
            .scaleEffect(animateScale ? endScale / 2 : startScale / 2)
            .foregroundColor(color)

        Rectangle().frame(width: size, height: size)
            .foregroundColor(.clear)
            .overlay(image)
            .offset(x: animateLine ? 0 : width - size)

    }

    /// Circle shell for image template
    /// - Parameter width: Available width size for component
    /// - Returns: View
    private func shellTpl(_ width: CGFloat) -> some View {
        Circle()
            .trim(from: 0, to: trim)
            .stroke(
            style: StrokeStyle(
                lineWidth: lineHeight,
                lineCap: .round
            )
        )
            .stroke(color)
            .frame(width: size, height: size)
            .rotationEffect(.degrees(90))
            .scaleEffect(animateScale ? endScale : startScale)
            .offset(x: animateLine ? 0 : width - size)
    }


}

#if DEBUG
struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            SearchFieldShell(text: .constant("search text"))
                .padding(.horizontal)
                .offset(y: proxy.size.height / 3)
                
        }.background(.black)
        
    }
}
#endif

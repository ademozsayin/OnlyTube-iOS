//
//  SplashView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 18.07.2024.
//

import SwiftUI
import DesignSystem
import Env

@MainActor
struct SplashView: View {
    
    @State private var startKeyframeAnimaton = false
    @State private var trigger: (Bool, Bool , Bool) = (false, false, false)

    @Environment(Theme.self) private var theme
    @Environment(UserPreferences.self) private var userPreferences

    var iconName: String {
#if targetEnvironment(macCatalyst)
        return "splashMac"
#else
        if let alternateIconName = UIApplication.shared.alternateIconName {
            return IconSelectorView.Icon(string: alternateIconName).appIconName
        } else {
            return "AppIcon"
        }
#endif
    }
    
    var body: some View {
        VStack {
            
            Spacer()
            
            GlitchTextView("OnsaTube", trigger: trigger.0)
                .font(.scaledSplash)
                .fontWeight(.semibold)
            
            Spacer()
            
            Image(uiImage: .init(named: iconName)!)
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .keyframeAnimator(initialValue: Keyframe(), trigger: startKeyframeAnimaton) { view, frame in
                    view
                        .scaleEffect(frame.scale)
                        .rotationEffect(frame.rotation, anchor: .bottom)
                        .offset(y: frame.offsetY)
                    /// Reflection
                        .background {
                            view
                            /// Little Blur
                                .blur(radius: 3)
                                .rotation3DEffect(
                                    .degrees(180),
                                    axis: (x: 1.0, y: 0.0, z: 0.0))
                                .mask(
                                    LinearGradient(colors: [
                                        .white.opacity(frame.reflectionOpacity),
                                        .white.opacity(frame.reflectionOpacity - 0.3),
                                        .white.opacity(frame.reflectionOpacity - 0.45),
                                        .clear
                                    ], startPoint: .top, endPoint: .bottom)
                                )
                                .offset(y: 195)
                        }
                    /// Mask
                    
                } keyframes: { frame in
                    KeyframeTrack(\.offsetY) {
                        CubicKeyframe(10, duration: 0.15)
                        SpringKeyframe(-100, duration: 0.3, spring: .bouncy)
                        CubicKeyframe(-100, duration: 0.45)
                        SpringKeyframe(0, duration: 0.3, spring: .bouncy)
                    }
                    
                    KeyframeTrack(\.scale) {
                        CubicKeyframe(0.9, duration: 0.15)
                        CubicKeyframe(1.2, duration: 0.3)
                        CubicKeyframe(1.2, duration: 0.3)
                        CubicKeyframe(1, duration: 0.3)
                    }
                    
                    KeyframeTrack(\.rotation) {
                        CubicKeyframe(.zero, duration: 0.15)
                        CubicKeyframe(.zero, duration: 0.3)
                        CubicKeyframe(.init(degrees: -20), duration: 0.1)
                        CubicKeyframe(.init(degrees: 20), duration: 0.1)
                        CubicKeyframe(.init(degrees: -20), duration: 0.1)
                        CubicKeyframe(.init(degrees: 0), duration: 0.15)
                    }
                    
                    KeyframeTrack(\.reflectionOpacity) {
                        CubicKeyframe(0.5, duration: 0.15)
                        CubicKeyframe(0.3, duration: 0.75)
                        CubicKeyframe(0.5, duration: 0.3)
                    }
                    
                } //: KEYFRAME ANIMATION IMAGE
            
            
            Spacer()
            
           
            .fontWeight(.bold)
            
        }
        .padding()
        .onAppear {
            startKeyframeAnimaton.toggle()
            
            Task {
                trigger.0.toggle()
                try? await Task.sleep(for: .seconds(0.5))
                trigger.0.toggle()
                try? await Task.sleep(for: .seconds(0.5))
                trigger.0.toggle()
                try? await Task.sleep(for: .seconds(0.5))
                trigger.0.toggle()
                try? await Task.sleep(for: .seconds(0.5))
                trigger.0.toggle()
                try? await Task.sleep(for: .seconds(0.5))
                trigger.0.toggle()
            }
        }
        
    }
    
    @MainActor
    @ViewBuilder
    private func GlitchTextView(_ text: String, trigger: Bool) -> some View {
        ZStack {
            
            GlitchText(text: text, trigger: trigger) {
                LinearKeyframe(
                    GlitchFrame(top: -5, center: 0, bottom: 0, shadowOpacity: 0.2),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: -5, center: -5, bottom: -5, shadowOpacity: 0.6),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: -5, center: 0, bottom: 5, shadowOpacity: 0.8),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: 5, center: 5, bottom: 5, shadowOpacity: 0.4),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: 5, center: 0, bottom: 5, shadowOpacity: 0.1),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(),
                    duration: 0.1
                )
                
            } //: Glitch Text
            
            GlitchText(text: text, trigger: trigger, shadow: theme.tintColor) {
                LinearKeyframe(
                    GlitchFrame(top: 0, center: 5, bottom: 0, shadowOpacity: 0.2),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: 5, center: 5, bottom: 5, shadowOpacity: 0.3),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: 5, center: 5, bottom: -5, shadowOpacity: 0.5),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: 0, center: 5, bottom: -5, shadowOpacity: 0.6),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: 0, center: -5, bottom: 0, shadowOpacity: 0.3),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(),
                    duration: 0.1
                )
                
            } //: Glitch Text
            
        } //: ZSTACK
    }
}

struct Keyframe {
    var scale: CGFloat = 1
    var offsetY: CGFloat = 0
    var rotation: Angle = .zero
    var reflectionOpacity: CGFloat = 0.5
}


struct GlitchFrame: Animatable {
    
    var animatableData: AnimatablePair<CGFloat, AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>>> {
        get {
            return .init(top, .init(center, .init(bottom, shadowOpacity)))
        }
        set {
            top = newValue.first
            center = newValue.second.first
            bottom = newValue.second.second.first
            shadowOpacity = newValue.second.second.second
        }
    }
    
    var top: CGFloat = 0
    var center: CGFloat = 0
    var bottom: CGFloat = 0
    var shadowOpacity: CGFloat = 0
}

/// Result Builder
@resultBuilder
struct GlitchFrameBuilder {
    static func buildBlock(_ components: LinearKeyframe<GlitchFrame>...) -> [LinearKeyframe<GlitchFrame>] {
        return components
    }
}

struct GlitchText: View {
    
    // MARK: - Properties
    var text: String
    
    /// Config
    var trigger: Bool
    var shadow: Color
    var radius: CGFloat
    var frames: [LinearKeyframe<GlitchFrame>]
    
    init(text: String, trigger: Bool, shadow: Color = .red, radius: CGFloat = 1, @GlitchFrameBuilder frames: @escaping ()-> [LinearKeyframe<GlitchFrame>]) {
        self.text = text
        self.trigger = trigger
        self.shadow = shadow
        self.radius = radius
        self.frames = frames()
    }
    
    var body: some View {
        KeyframeAnimator(initialValue: GlitchFrame(), trigger: trigger) { value in
            ZStack {
                TextView(.top, offset: value.top, opacity: value.shadowOpacity)
                TextView(.center, offset: value.center, opacity: value.shadowOpacity)
                TextView(.bottom, offset: value.bottom, opacity: value.shadowOpacity)
            } //: ZSTACK
            //.compositingGroup()
        } keyframes: { value in
            for frame in frames {
                frame
            }
        }
        
    }
    
    
    // MARK: - Views
    
    @ViewBuilder
    func TextView(_ alignment: Alignment, offset: CGFloat, opacity: CGFloat) -> some View {
        Text(text)
            .mask {
                if alignment == .top {
                    VStack(spacing: 0) {
                        Rectangle()
                        ExtendedSpacer()
                        ExtendedSpacer()
                    } //: VSTACK
                } else if alignment == .center {
                    VStack(spacing: 0) {
                        ExtendedSpacer()
                        Rectangle()
                        ExtendedSpacer()
                    } //: VSTACK
                } else {
                    VStack(spacing: 0) {
                        ExtendedSpacer()
                        ExtendedSpacer()
                        Rectangle()
                    } //: VSTACK
                }
            }
            .shadow(color: shadow.opacity(opacity), radius: radius, x: offset, y: offset / 2)
            .offset(x: offset)
    }
    
    
    @ViewBuilder
    private func ExtendedSpacer() -> some View {
        Spacer(minLength: 0)
            .frame(maxHeight: .infinity)
    }
    
}
//
//#Preview {
//    GlitchText(text: "MatBuompy", trigger: true) {
//        
//    }
//}

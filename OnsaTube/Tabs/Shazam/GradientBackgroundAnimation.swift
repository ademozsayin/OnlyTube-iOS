
import SwiftUI
import DesignSystem

struct GradientBackgroundAnimation<Content: View>: View {
    @State private var animateGradient: Bool = false
    
    private let startColor: Color = Color.fenerbahceDarkBlue
    private let endColor: Color = Color.yellow
    
    let content: () -> Content
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [startColor, endColor], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                .hueRotation(.degrees(animateGradient ? 45 : 0))
                .onAppear {
                    withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
            content()
        }
        .foregroundColor(.black)
        .multilineTextAlignment(.center)
    }
}


struct GradientBackgroundAnimation_Previews: PreviewProvider {
    static var previews: some View {
        GradientBackgroundAnimation {
            Text("")
        }
    }
}

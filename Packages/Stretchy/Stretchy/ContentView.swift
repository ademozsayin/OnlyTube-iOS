// 🔥BOYCOTT on russia - terrorist must be punished!
// «Русский военный корабль, иди на хуй!» (c) Ukrainian Frontier Guard
//
// ATTENTION: This is a demo - use it as you wish. Reference is appriciated.
// If you want to thank - buy me coffee: https://secure.wayforpay.com/donate/asperi

import SwiftUI

struct ContentView: View {
    @State var imageHeight: CGFloat = 0
    let headerHeight: CGFloat = 200
    
    var body: some View {
        ScrollView {
            // just remove .sectionHeaders to make it non-sticky
            LazyVStack(spacing: 8, pinnedViews: [.sectionHeaders]) {
                Section {
                    // >> any content
                    ForEach(0..<100) {
                        Text("Item \($0)")
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(RoundedRectangle(cornerRadius: 12).fill($0%2 == 0 ? .blue : .yellow))
                            .padding(.horizontal)
                    }
                    // << content end
                } header: {
                    // here is only caculable part
                    GeometryReader {
                        // detect current position of header bottom edge
                        Color.clear.preference(key: ViewOffsetKey.self,
                                               value: $0.frame(in: .named("area")).maxY)
                    }
                    .frame(height: headerHeight)
                    .onPreferenceChange(ViewOffsetKey.self) { offset in
                        print(offset)
                        // prevent image illegal if header is not pinned
                        imageHeight = offset < 0 ? 0.001 : offset
//                        imageHeight = 200 + max(0 - $0.)
                    }
                }
            }
        }
        .coordinateSpace(name: "area")
        .overlay(
            // >> any header
            Image(.bg)
                .resizable()
                .scaledToFill()
                .frame(height: imageHeight)
                .clipped()
                .allowsHitTesting(false)
            , alignment: .top)
        .clipped()
    }
}

struct TestFlexibleStickyHeader_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/// A preference key to store ScrollView offset
public struct ViewOffsetKey: PreferenceKey {
    public typealias Value = CGFloat
    public static var defaultValue = CGFloat.zero
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

import SwiftUI

/**
    Dynamic Scroll View of Toss.
 
        TossScrollView("Home") {
            AnyView()
        }
 */
@available(macOS 11, iOS 14, *)
public struct TossScrollView<Content: View>: View {
    
    @State var shrink: Bool = false
    let title: String
    let showsIndicators: Bool
    let content: Content
    
    /**
        - Parameters:
           - title: Title of the View.
           - showsIndicators: To show indicators or not.
     */
    public init(_ title: String,
                showsIndicators: Bool = true,
                @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.showsIndicators = showsIndicators
        self.content = content()
    }
    
    public var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .opacity(shrink ? 1 : 0)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
            GeometryReader { outsideProxy in
                ScrollView(showsIndicators: showsIndicators) {
                    VStack(spacing: 36) {
                        GeometryReader { insideProxy in
                            Text(title)
                                .font(.system(size: 26, weight: .bold))
                                .padding(.leading, 24)
                                .onChange(of: insideProxy.frame(in: .global).minY) { newValue in
                                    DispatchQueue.main.async {
                                        let proxy = outsideProxy.frame(in: .global).minY - newValue
                                        withAnimation(.default) {
                                            shrink = proxy > 36
                                        }
                                    }
                                }
                        }
                        content
                    }
                }
            }
        }
    }
}

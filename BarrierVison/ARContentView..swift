import SwiftUI
import RealityKit
import ARKit
import Combine

struct ARContentView: View {
    @State private var showPopup = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            ARViewContainer(showPopup: $showPopup)
            
            // アイコンをタップしたときのアクションを追加
            Button(action: {
                self.showPopup = true
                
                // 3秒後にポップアップを非表示にする
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.showPopup = false
                }
            }) {
                IconAndPopupView(showPopup: $showPopup)
            }
            .padding(.leading, 10)
            .padding(.top, 10)
            .buttonStyle(PlainButtonStyle()) // デフォルトのボタンスタイルをオフにする
        }
    }
}

struct IconAndPopupView: View {
    @Binding var showPopup: Bool

    var body: some View {
        HStack(spacing: 0) {
            CircleIconView()
            
            if showPopup {
                RoundedPopupView()
            }
        }
        .animation(.spring())
    }
}

struct CircleIconView: View {
    var body: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 60, height: 60)
            .shadow(radius: 10)
    }
}

struct RoundedPopupView: View {
    var body: some View {
        Text("歩行者とすれ違い可能!")
            .foregroundColor(.black)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var showPopup: Bool

    class CustomARView: ARView {
        var updateToken: Cancellable?
    }

    func makeUIView(context: Context) -> ARView {
        let arView = CustomARView(frame: .zero)

        // ここで人とのすれ違いを検出するロジックを追加できます。
        // 簡単のため、5秒後にポップアップを表示するようにします。
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showPopup = true
            
            // 3秒後にポップアップを非表示にする
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showPopup = false
            }
        }

        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

import SwiftUI
import RealityKit
import ARKit
import Combine

struct ARContentView: View {
    @State private var showPopup = false
    @State private var iconImageName = "img" // 初期画像の名前
    @State private var popupText = "歩行者とすれ違い可能!" // 初期のポップアップテキスト

    var body: some View {
        ZStack(alignment: .topLeading) {
            ARViewContainer(showPopup: $showPopup)
                .edgesIgnoringSafeArea(.all)
            
            Button(action: {
                self.showPopup = true
                
                // 3秒後にアイコンの画像とポップアップのテキストを変更
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.iconImageName = "img2" // 新しい画像の名前に変更
                    self.popupText = "車いすとすれ違い可能！" // 新しいポップアップテキストに変更
                    
                    // 更に3秒後にポップアップを非表示にする
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.showPopup = false
                    }
                }
            }) {
                IconAndPopupView(showPopup: $showPopup, imageName: $iconImageName, popupText: $popupText)
            }
            .padding(.leading, 10)
            .padding(.top, 10)
            .buttonStyle(PlainButtonStyle()) // デフォルトのボタンスタイルをオフにする
        }
    }
}

struct IconAndPopupView: View {
    @Binding var showPopup: Bool
    @Binding var imageName: String
    @Binding var popupText: String

    var body: some View {
        HStack(spacing: 0) {
            CircleIconView(imageName: imageName)
            
            if showPopup {
                RoundedPopupView(popupText: popupText)
            }
        }
        .animation(.spring())
    }
}

struct CircleIconView: View {
    var imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .shadow(radius: 10)
    }
}

struct RoundedPopupView: View {
    var popupText: String

    var body: some View {
        Text(popupText)
            .foregroundColor(.black)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
    }
}

// ... 以下のコードは変更なし ...


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
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showPopup = false
            }
        }

        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

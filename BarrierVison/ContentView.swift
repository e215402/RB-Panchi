////
////  ContentView.swift
////  BarrierVison
////
////  Created by e215402 on 2023/09/26.
////
//
//import SwiftUI
//import RealityKit
////import ARKit
//import Combine
//
//
//struct ContentView: View {
//    var body: some View {
//        NavigationView{
//            VStack(spacing: 10) {
//                Spacer()
//                Image("Image1")
//                    .resizable()  // 画像のサイズを変更できるようにする
//                    .scaledToFit()  // アスペクト比を保ちながら画像をフィットさせる
//                //                .frame(width: 100, height: 100)  // ここで画像の幅と高さを指定
//                
//                //            Text("BarrierVison")
//                //                .font(.largeTitle)
//                //                .fontWeight(.bold)
//                //
//                //            Button("START"){
//                //            }
//                //                .font(.title2)
//                //                .fontWeight(.bold)
//                //        }
//                Spacer()
//                NavigationLink(destination: ARContentView()) {
//                    Text("START")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                
//                NavigationLink(destination: ExplainView()){
//                    Text("ABOUT")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//            }
//            .padding()
//            .background(Color.white)
//        }
//    }
//}
//
//struct ARContentView : View {
//    
//    class Coordinator {
//        var updateToken: Cancellable?
//    }
//    
//    var body: some View {
//        ARViewContainer().edgesIgnoringSafeArea(.all)
//    }
//}
//
//extension float4x4 {
//    var forwardVector: SIMD3<Float> {
//        let forward = SIMD3<Float>(-columns.2.x, -columns.2.y, -columns.2.z)
//        return normalize(forward)
//    }
//}
//
//
//struct ARViewContainer: UIViewRepresentable {
//    
//    class CustomARView: ARView {
//        var updateToken: Cancellable?
//    }
//    
//    func makeUIView(context: Context) -> ARView {
//        let arView = CustomARView(frame: .zero)
//        let boxSize = SIMD3<Float>(0.5, 0.8, 0.7)
//        let mesh = MeshResource.generateBox(size: boxSize)
//        let material = SimpleMaterial(color: .green, isMetallic: false)
//        let model = ModelEntity(mesh: mesh, materials: [material])
//        
//        //壁認識コード　ここをコメントアウトするとキューブが見える
////        arView.automaticallyConfigureSession = false
////        let configuration = ARWorldTrackingConfiguration()
////        configuration.sceneReconstruction = .meshWithClassification
////        arView.debugOptions.insert(.showSceneUnderstanding)
////        arView.session.run(configuration)
//        //壁認識コード
//
//        model.name = "WheelChair"
//        
//        let anchor = AnchorEntity(.plane(.horizontal, classification: .floor, minimumBounds: SIMD2<Float>(0.7, 1.2)))
//        anchor.children.append(model)
//        arView.scene.anchors.append(anchor)
//
//        arView.updateToken = arView.scene.subscribe(to: SceneEvents.Update.self) { [weak arView] event in
//            guard let arView = arView else { return }
//            
//            if let model = arView.scene.findEntity(named: "WheelChair") as? ModelEntity {
//                let cameraPosition = arView.cameraTransform.translation
//                let cameraForward = arView.cameraTransform.matrix.forwardVector
//                
//                // カメラの位置と少し前方にオブジェクトを配置
//                let objectDistance: Float = 0.01  // 1メートル前方にオブジェクトを配置
//                let objectPosition = cameraPosition + cameraForward * objectDistance
//                
//                // yの座標は変更しない
//                model.position = SIMD3<Float>(objectPosition.x, model.position.y, objectPosition.z)
//                
//                // オブジェクトのオリエンテーションをカメラのy軸回転にのみ合わせる
//                let yAxisRotation = atan2(cameraForward.x, cameraForward.z)
//                model.orientation = simd_quatf(angle: yAxisRotation, axis: SIMD3<Float>(0, 1, 0))
//            }
//        }
//
//        return arView
//    }
//    
//    func updateUIView(_ uiView: ARView, context: Context) {}
//}
//
//
//
//
//
//
//
//struct ExplainView: View{
//    var body: some View{
//        VStack(spacing: 10){
//            Text("このアプリは車いす体験のできるARアプリです")
//                .font(.title)  // タイトルのサイズを指定
//                .fontWeight(.semibold)  // テキストの太さを指定
//                .multilineTextAlignment(.center)  // テキストを中央揃えにする
//                .padding()  // テキストの周りにスペースを追加
//            
//        }
//        .padding()
//        .background(Color.white)
//    }
//    
//}
//
//#Preview {
//    ContentView()
//}

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainNavigationView()
    }
}


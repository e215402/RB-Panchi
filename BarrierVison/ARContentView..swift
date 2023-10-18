import SwiftUI
import RealityKit
import ARKit
import Combine

//コメントアウトしたコードは消さないでね．汚いけど．．

// ARの距離情報を保持するクラス
class ARdistanceState: ObservableObject {
    @Published var distance: Float = 0.0
    @Published var isGo: String = "YES"
}

// ARコンテンツを表示するためのView
struct ARContentView: View {
    @ObservedObject var distanceStateR = ARdistanceState()
    @ObservedObject var distanceStateL = ARdistanceState()
    @ObservedObject var distanceStateM = ARdistanceState()
    // ARViewの更新を管理するクラス
    class Coordinator {
        var updateToken: Cancellable?
    }
    
    
    var body: some View {
        //HStack == Horizontal stack,
        //VStack == Vertical stack,
        //ZStack == Z-axis stack
        
        //アプリ実行時の各計測距離を表示するブロック
        VStack{
            ARViewContainer(distanceStateR: distanceStateR,
                            distanceStateL: distanceStateL,
                            distanceStateM: distanceStateM).edgesIgnoringSafeArea(.all)
            
            Text("DistanceR : \(distanceStateR.distance, specifier: "%.2f") m")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                            .padding()
            
            Text("DistanceL : \(distanceStateL.distance, specifier: "%.2f") m")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                            .padding()
            Text("Height : \(distanceStateM.distance, specifier: "%.2f") m")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                            .padding()
            
        }
    }
}


/*
extension float4x4 {
    var forwardVector: SIMD3<Float> {
        let forward = SIMD3<Float>(-columns.2.x, -columns.2.y, -columns.2.z)
        return normalize(forward)
    }
}
*/

/*
 raycastを使用してます
 LiDARセンサーから左右15°ずつの角度で飛ばして反射で帰ってきた距離を見る
 仮に左側に壁があった場合，左の距離は距離R >距離Lであるので左側に障害物があることがわかる
 というコードです
 
 */
struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var distanceStateR: ARdistanceState //右側のレーザーからの反射距離
    @ObservedObject var distanceStateL: ARdistanceState //同左側
    @ObservedObject var distanceStateM: ARdistanceState //中点　使ってない
    
    class CustomARView: ARView {
        var updateToken: Cancellable?
    }

    func makeUIView(context: Context) -> ARView {
        let arView = CustomARView(frame: .zero)
        
        /*
        // AR debug-mod
        arView.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.sceneReconstruction = .meshWithClassification
        arView.debugOptions.insert(.showSceneUnderstanding)
        arView.session.run(configuration)
        */
    
        
        /* create wheel-chair model

        // setting model
        let boxSize = SIMD3<Float>(0.1, 0.1, 0.1)
        let mesh = MeshResource.generateBox(size: boxSize)
        let material = SimpleMaterial(color: .green, isMetallic: false)
        let model = ModelEntity(mesh: mesh, materials: [material])
        model.name = "WheelChair"
        // setting anchor
        let anchor = AnchorEntity(.plane(.horizontal, classification: .floor, minimumBounds: SIMD2<Float>(0.7, 1.2)))
        anchor.children.append(model)
        arView.scene.anchors.append(anchor)
        */
        
        
        // update arview
        arView.updateToken = arView.scene.subscribe(to: SceneEvents.Update.self) { [weak arView] event in
            guard let arView = arView else { return }
            
            //if let model = arView.scene.findEntity(named: "WheelChair") as? ModelEntity {
                
            //
            //arView.cameraTransform.matrix
            //| R11  R12  R13  Tx |
            //| R21  R22  R23  Ty |
            //| R31  R32  R33  Tz |
            //|  0    0    0   1  |
            // Rxx == Rotation, Tx == Translation , [x,3] == fixed value,
            // Rx1 == how many rotate right<x-axis>,
            // Rx2 == how horizontal between x-axis and y-axis,
            // Rx3 == how horizontal between x-axis and z-axis
            let cameraMatrix = arView.cameraTransform.matrix
            let cameraPosition = cameraMatrix.columns.3
            let cameraRotate = cameraMatrix.columns.2
            
            /*
            //setting object position
            let objectDistance: Float = 2.0
            let objectX = (cameraPosition.x + moving.x * objectDistance)
            let objectY : Float = -1.6
            let objectZ = (cameraPosition.z + moving.z * objectDistance)

            // object positioning
            let objectPosition = SIMD3<Float>(objectX, objectY, objectZ)
            model.position = SIMD3<Float>(objectPosition.x, 0, objectPosition.z)
            model.look(at: cameraPosition, from: objectPosition, relativeTo: nil)
            */
                
            // Raycastの設定
            let raycastOrigin = SIMD3<Float>(cameraPosition.x, cameraPosition.y, cameraPosition.z)
            //print(raycastOrigin)
            //Right raycast
            let raycastDirectionR = -SIMD3<Float>(cameraRotate.x+0.25, cameraRotate.y, cameraRotate.z)
            let raycastQueryR = ARRaycastQuery(origin: raycastOrigin,
                                              direction: raycastDirectionR,
                                              allowing: .estimatedPlane,
                                              alignment: .any)
            //Left raycast
            let raycastDirectionL = -SIMD3<Float>(cameraRotate.x-0.25, cameraRotate.y, cameraRotate.z)
            let raycastQueryL = ARRaycastQuery(origin: raycastOrigin,
                                              direction: raycastDirectionL,
                                              allowing: .estimatedPlane,
                                              alignment: .any)
            //middle raycast
            let raycastDirectionM = -SIMD3<Float>(cameraRotate.x, cameraRotate.y, cameraRotate.z)
            let raycastQueryM = ARRaycastQuery(origin: raycastOrigin,
                                              direction: raycastDirectionM,
                                              allowing: .estimatedPlane,
                                              alignment: .any)            // result
                
                if let resultR = arView.session.raycast(raycastQueryR).first ,
                    let resultL = arView.session.raycast(raycastQueryL).first ,
                    let resultM = arView.session.raycast(raycastQueryM).first {
                    let hitDistanceR = length(resultR.worldTransform.columns.3)
                    let hitDistanceL = length(resultL.worldTransform.columns.3)
                    //let hitDistanceM = length(resultM.worldTransform.columns.3)
                    //print(result.worldTransform.columns.3)
                    
                    //create anchor at the raycasting place
                    //let anchorR = AnchorEntity(world: resultR.worldTransform)
                    //let anchorL = AnchorEntity(world: resultL.worldTransform)
                    /*
                     今回のコードではオブジェクトを動かすのではなくてアンカーが移動した箇所に
                     新しくオブジェクトを追加した．
                     */
                    let anchorM = AnchorEntity(world: resultM.worldTransform)
                    
                    let boxSize = SIMD3<Float>(0.02, 0.02, 0.02)
                    let mesh = MeshResource.generateBox(size: boxSize)
                    let material = SimpleMaterial(color: .green, isMetallic: false)
                    let materialFalse = SimpleMaterial(color: .red, isMetallic: false)
                    let modelEntity = ModelEntity(mesh: mesh, materials: [material])
                    let modelEntityFalse = ModelEntity(mesh: mesh, materials: [materialFalse])
                    
                    /*
                    anchorR.addChild(modelEntity)
                    anchorL.addChild(modelEntity)
                    anchorM.addChild(modelEntity)
                    arView.scene.addAnchor(anchorR)
                    arView.scene.addAnchor(anchorL)
                    arView.scene.addAnchor(anchorM)
                    */
                    
                    //place model
                    let height = abs(hitDistanceL-hitDistanceR)
                    if  height > 0.01{
                            print("find obstacle ->",height)
                        
                            anchorM.addChild(modelEntityFalse)
                            arView.scene.addAnchor(anchorM)
                    } else{
                            anchorM.addChild(modelEntity)
                            arView.scene.addAnchor(anchorM)
                    }
                    
                    //printout
                    DispatchQueue.main.async{
                        self.distanceStateR.distance = hitDistanceR
                        self.distanceStateL.distance = hitDistanceL
                        self.distanceStateM.distance = height
                    }
                } else {
                    DispatchQueue.main.async{
                        self.distanceStateR.distance = 0.0
                        self.distanceStateR.distance = 0.0
                        self.distanceStateM.distance = 0.0
                    }
                }

        }
        return arView
    }
    func updateUIView(_ uiView: ARView, context: Context) {}
}







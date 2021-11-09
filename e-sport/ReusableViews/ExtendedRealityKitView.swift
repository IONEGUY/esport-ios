//
//  ExtendedRealityKitView.swift
//  SmARt
//
//  Created by MacBook on 23.02.21.
//

import Foundation
import ARKit
import RealityKit
import Alamofire
import Combine
import SceneKit

class ExtendedRealityKitView: ARView, ARSessionDelegate {
    private let defaultZOffset: Float = -2
    private let defaultContentScaleFactorMultiplier: CGFloat = 0.5
    private let videoPlaneWidth: Float = 1
    private let videoPlaneHeight: Float = 0.5
    
    private var cancellables = Set<AnyCancellable>()
    private var disposables: [Disposable] = []
    private var coachingOverlay = ARCoachingOverlayView()
    
    private var interactionsEnadled = true
    private var trackingImages: [UIImage: String] = [:]
    private var hologramAnchors: [String : HasAnchoring] = [:]
    
    var imageRecognized = PassthroughSubject<Void, Never>()
    var delegate: ExtendedRealityKitViewDelegate?
    static var shared = ExtendedRealityKitView()
    
    func setup() {
        configueARSession()
        setupOptimizations()
        addGestureRecognizers()
        createLightingAnchor()
    }
    
    func releaseResources() {
        disposables.forEach { $0.dispose() }
        disposables = []
        hologramAnchors = [:]
    }
    
    func addToGroup(withName name: String, anchor: HasAnchoring) {
        var groupAnchor = getGroupAnchor(name)
        if groupAnchor == nil {
            groupAnchor = AnchorEntity()
            groupAnchor?.name = name
            scene.anchors.append(groupAnchor ?? AnchorEntity())
        }
        
        groupAnchor?.addChild(anchor)
    }
    
    func hideGroup(withName name: String) {
        getGroupAnchor(name)?.isEnabled = false
    }
    
    func showGroup(withName name: String) {
        getGroupAnchor(name)?.isEnabled = true
    }
    
    func removeGroup(withName name: String) {
        getGroupAnchor(name)?.removeFromParent()
    }

    func configueARSession() {
        interactionsEnadled = true
        session.delegate = self
        let configuration = ARWorldTrackingConfiguration()
        session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
    }
    
    func configueImageTrackingARSession(trackingImages: [UIImage: String]) {
        interactionsEnadled = false
        self.trackingImages = trackingImages
        let referenceImages: [ARReferenceImage] = trackingImages.keys.compactMap {
            guard let cgImage = $0.cgImage else { return nil }
            let referenceImage = ARReferenceImage(cgImage, orientation: .down, physicalWidth: 0.5)
            referenceImage.name = $0.accessibilityIdentifier ?? .empty
            return referenceImage
        }

        session.delegate = self
        let config = ARImageTrackingConfiguration()
        config.isAutoFocusEnabled = true
        config.trackingImages = Set(referenceImages)
        config.maximumNumberOfTrackedImages = referenceImages.count
        session.run(config, options: [.removeExistingAnchors, .resetTracking])
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        anchors
            .compactMap { $0 as? ARImageAnchor }
            .forEach { [unowned self] imageAnchor in
                guard let imageAnchorName = imageAnchor.referenceImage.name,
                      let image = trackingImages.keys.first(where:
                          { $0.accessibilityIdentifier == imageAnchorName }),
                      let video = trackingImages[image]
                      else { return }

                imageRecognized.send()
                attachVideoToImageAnchor(video, imageAnchor, imageAnchorName)
            }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        anchors
            .compactMap { $0 as? ARImageAnchor }
            .forEach { [unowned self] imageAnchor in
                guard let imageAnchorName = imageAnchor.referenceImage.name,
                      let hologramAnchor = hologramAnchors[imageAnchorName]
                else { return }
                
                hologramAnchor.isEnabled = imageAnchor.isTracked
                hologramAnchor.transform = Transform(matrix: imageAnchor.transform)
                scene.anchors.append(hologramAnchor)
            }
    }

    func createLightingAnchor() {
        let lightAnchor = AnchorEntity()
        lightAnchor.addChild(DefaultLightingEntity())
        scene.anchors.append(lightAnchor)
    }
    
    @discardableResult
    func appendVideo(_ id: String, _ transform: simd_float4x4, groupName: String? = nil) -> ModelEntity {
        if scene.findEntity(named: id) != nil { return ModelEntity() }
        
        let url = URL.constructFilePath(withName: "\(id).mp4")
        
        let videoPlayer = AVPlayer(playerItem: AVPlayerItem(url: url))
        disposables.append(Disposable(dispose: { videoPlayer.isMuted = true; videoPlayer.pause() }))

        let videoPlane = ModelEntity(mesh: .generatePlane(width: videoPlaneWidth,
                                                          height: videoPlaneHeight),
                                     materials: [VideoMaterial(avPlayer: videoPlayer)])
        videoPlayer.play()
        videoPlane.generateCollisionShapes(recursive: true)
        addAnchorToARView(transform, videoPlane, id, groupName)
        
        return videoPlane
    }
    
    func append3DModel(_ id: String, _ transform: simd_float4x4, groupName: String? = nil) -> AnyPublisher<ModelEntity, Never> {
        AnyPublisher.create { [unowned self] observer in
            if scene.findEntity(named: id) != nil { return .init(dispose: {}) }
            
            let filePath = URL.constructFilePath(withName: "\(id).usdz")
            Entity.loadModelAsync(contentsOf: filePath).sink {_ in}
                receiveValue: { [unowned self] model in
                    addAnchorToARView(transform, model, id, groupName)
                    model.availableAnimations.forEach { if #available(iOS 15.0, *) {
                        model.playAnimation($0.repeat())
                    } else {
                        // Fallback on earlier versions
                    } }
                    observer.onNext(model)
                    observer.onComplete()
                }
                .store(in: &cancellables)
            return .init(dispose: {})
        }
    }
    
    func append3DModel(modelName: String, _ transform: simd_float4x4, groupName: String? = nil) -> AnyPublisher<ModelEntity, Never> {
        AnyPublisher.create { [unowned self] observer in
            if scene.findEntity(named: modelName) != nil { return .init(dispose: {}) }
            
            Entity.loadModelAsync(named: modelName).sink {_ in}
                receiveValue: { [unowned self] model in
                    addAnchorToARView(transform, model, modelName, groupName)
                    model.availableAnimations.forEach { if #available(iOS 15.0, *) {
                        model.playAnimation($0.repeat())
                    } else {
                        // Fallback on earlier versions
                    } }
                    observer.onNext(model)
                    observer.onComplete()
                }
                .store(in: &cancellables)
            return .init(dispose: {})
        }
    }
    
    func appendModelOnCenter(_ name: String, groupName: String? = nil) -> AnyPublisher<ModelEntity, Never> {
        if let currentFrame = session.currentFrame {
            var translation = matrix_identity_float4x4
            translation.columns.3.z = defaultZOffset
            translation.columns.3.x = 0.8
            translation.columns.3.y = -0.2
            let transformMatrix = simd_mul(currentFrame.camera.transform, translation)
            var transform = Transform(matrix: transformMatrix)
            transform.rotation = simd_quatf(angle: currentFrame.camera.eulerAngles.y, axis: SIMD3<Float>(0, 1, 0))
            return append3DModel(modelName: name, transform.matrix, groupName: groupName)
        }
        
        return .init(Empty())
    }
    
    private func attach3dObjectToImageAnchor(_ model: FileData, _ imageAnchor: ARImageAnchor, _ imageAnchorName: String) {
        append3DModel(model.entityId, imageAnchor.transform, groupName: "Holograms")
            .sink { [unowned self] model in
                let modelVisualBounds = model.visualBounds(relativeTo: model)
                let min = modelVisualBounds.min
                let max = modelVisualBounds.max
                let modelWidth = CGFloat(max.x - min.x)
                let imageWidth = imageAnchor.referenceImage.physicalSize.width
                let scaleFactor = imageWidth / modelWidth
                model.scale = SIMD3<Float>(SCNVector3(scaleFactor, scaleFactor, scaleFactor))
                hologramAnchors[imageAnchorName] = model.anchor
            }
            .store(in: &cancellables)
    }
    
    private func attachVideoToImageAnchor(_ video: String, _ imageAnchor: ARImageAnchor, _ imageAnchorName: String) {
        guard let path = Bundle.main.path(forResource: video, ofType:"mp4") else { return }
        let videoPlayer = AVPlayer(url: URL(fileURLWithPath: path))
        videoPlayer.actionAtItemEnd = .none
        disposables.append(Disposable(dispose: { videoPlayer.isMuted = true }))

        let videoPlaneSize = imageAnchor.referenceImage.physicalSize
        let videoPlane = ModelEntity(mesh: .generatePlane(
            width: Float(videoPlaneSize.width),
            depth: Float(videoPlaneSize.height)),
                                     materials: [VideoMaterial(avPlayer: videoPlayer)])
        videoPlayer.play()
        
        let anchor = AnchorEntity()
        anchor.transform = Transform(matrix: imageAnchor.transform)
        videoPlane.name = imageAnchorName
        videoPlane.orientation = simd_quatf(angle: .pi, axis: [0, 1, 0])
        anchor.name = imageAnchorName
        anchor.addChild(videoPlane)
        scene.anchors.append(anchor)
        
        addToGroup(withName: "Holograms", anchor: anchor)
        hologramAnchors[imageAnchorName] = anchor
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(playerItemDidReachEnd(notification:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: videoPlayer.currentItem)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    private func getGroupAnchor(_ name: String) -> HasAnchoring? {
        return scene.anchors.first(where: { $0.name == name })
    }
    
    private func setupOptimizations() {
        contentScaleFactor = defaultContentScaleFactorMultiplier * contentScaleFactor
        renderOptions = [.disableMotionBlur, .disableAREnvironmentLighting,
                         .disableCameraGrain, .disableDepthOfField,
                         .disableFaceOcclusions, .disableGroundingShadows,
                         .disableHDR, .disablePersonOcclusion]
    }
    
    private func addGestureRecognizers() {
        addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                    action: #selector(handleTapAction)))
    }
    
    private func addAnchorToARView(_ transform: simd_float4x4, _ model: ModelEntity, _ name: String, _ groupName: String? = nil) {
        let anchor = AnchorEntity()
        anchor.transform = Transform(matrix: transform)
        model.name = name
        anchor.name = name
        anchor.addChild(model)
        
        if let groupName = groupName {
            addToGroup(withName: groupName, anchor: anchor)
        } else {
            scene.anchors.append(anchor)
        }
    }
    
    @objc private func handleTapAction(_ sender: UITapGestureRecognizer) {
        if let currentFrame = session.currentFrame {
            var translation = matrix_identity_float4x4
            translation.columns.3.z = defaultZOffset
            let transformMatrix = simd_mul(currentFrame.camera.transform, translation)
            var transform = Transform(matrix: transformMatrix)
            transform.rotation = simd_quatf(angle: currentFrame.camera.eulerAngles.y, axis: SIMD3<Float>(0, 1, 0))
            delegate?.doOnTap(self, transform.matrix)
        }

        let tapPoint = sender.location(in: self)
        let hit = hitTest(tapPoint).first
        if let tappedEntity = hit?.entity {
            delegate?.entitySelected(tappedEntity)
        }
    }
    
    @objc private func handleDoubleTapAction(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: self)
        let hit = hitTest(tapPoint).first
        if let tappedEntity = hit?.entity {
            delegate?.entitySelectedOnDoubleTap(tappedEntity)
        }
    }
}

private class DefaultLightingEntity: Entity, HasPointLight {
    required init() {
        super.init()
  
        light = PointLightComponent(color: .white, intensity: 60000)
    }
}

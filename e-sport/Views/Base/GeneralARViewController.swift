//
//  SmartRoomARViewController.swift
//  SmARt
//
//  Created by MacBook on 3.03.21.
//

import Foundation
import RealityKit
import UIKit
import SwiftUI
import Combine

class GeneralARViewController<ViewModelType: GeneralARViewModel>: BaseViewController, ExtendedRealityKitViewDelegate {
    @ObservedObject var viewModel: ViewModelType
    var currentModel = ModelEntity()
    var pauseARViewOnDisappear: Bool { true }
    
    var objects3DGroupName: String { Self.typeName }
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.$contentLoadingProgress
            .assign(to: \.loadingProgress, on: self)
            .store(in: &cancellables)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.insertSubview(ExtendedRealityKitView.shared, at: 0)
        ExtendedRealityKitView.shared.fillSuperview()
        ExtendedRealityKitView.shared.configueARSession()
        ExtendedRealityKitView.shared.delegate = self
        ExtendedRealityKitView.shared.showGroup(withName: objects3DGroupName)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ExtendedRealityKitView.shared.hideGroup(withName: objects3DGroupName)
        ExtendedRealityKitView.shared.releaseResources()
        ExtendedRealityKitView.shared.removeFromSuperview()
    }
    
    func doOnTap(_ sender: ExtendedRealityKitView , _ transform: simd_float4x4) {
        if viewModel.augmentedObjectType == .object3D {
            ExtendedRealityKitView.shared.append3DModel(viewModel.current3DObjectId, transform, groupName: objects3DGroupName)
                .sink(receiveValue: handle3DObjectAdded)
                .store(in: &cancellables)
        } else {
            ExtendedRealityKitView.shared.appendVideo(viewModel.current3DObjectId, transform, groupName: objects3DGroupName)
        }
    }
    
    func handle3DObjectAdded(modelEntity: ModelEntity) {
        currentModel = modelEntity
    }

    func entitySelected(_ entity: Entity) {}
    
    func entitySelectedOnDoubleTap(_ entity: Entity) { }
}

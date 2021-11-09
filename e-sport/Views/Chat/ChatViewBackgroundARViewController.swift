//
//  ChatViewBackgroundARViewController.swift
//  e-sport
//
//  Created by MacBook on 27.10.21.
//

import Foundation
import UIKit
import RealityKit
import Combine

class ChatViewBackgroundARViewController: GeneralARViewController<ChatViewModel> {
    override var objects3DGroupName: String { "Holo" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.$greatingAvatarAvailable
            .dropFirst()
            .first()
            .sink { [unowned self] _ in
                ExtendedRealityKitView.shared.appendModelOnCenter("avatar", groupName: objects3DGroupName)
                    .sink(receiveValue: handle3DObjectAdded)
                    .store(in: &cancellables)
                
                ExtendedRealityKitView.shared.isUserInteractionEnabled = false
                viewModel.sendHelpMessage()
            }
            .store(in: &cancellables)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        ExtendedRealityKitView.shared.appendModelOnCenter("avatar_touch", groupName: objects3DGroupName)
            .sink(receiveValue: handle3DObjectAdded)
            .store(in: &cancellables)
    }
    
    override func handle3DObjectAdded(modelEntity: ModelEntity) {
        currentModel.removeFromParent()
        currentModel = modelEntity
    }
}

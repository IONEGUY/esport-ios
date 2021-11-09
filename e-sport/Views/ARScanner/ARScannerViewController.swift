//
//  ARScannerViewController.swift
//  SmARt
//
//  Created by MacBook on 22.04.21.
//

import Foundation
import ARKit
import RealityKit
import Combine

class ARScannerViewController: GeneralARViewController<ARScannerViewModel> {
    override var objects3DGroupName: String { "Holograms" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Augmented reality"

        addProposalForInteractionMessage(withTitle: "Focus on image")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupTrackingImages()
        
        ExtendedRealityKitView.shared.imageRecognized
            .sink(receiveValue: removeProposalForInteractionMessage)
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupTrackingImages() {
        let horizontalPoster = UIImage(named: "poster_horizontal")!
        horizontalPoster.accessibilityIdentifier = "poster_horizontal"
        let verticalPoster = UIImage(named: "poster_vertical")!
        verticalPoster.accessibilityIdentifier = "poster_vertical"
        ExtendedRealityKitView.shared.configueImageTrackingARSession(trackingImages:
            [horizontalPoster: "poster_horizontal_animation",
             verticalPoster: "poster_vertical_animation"])
    }
}

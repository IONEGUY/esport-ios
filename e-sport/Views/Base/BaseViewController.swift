//
//  BaseViewController.swift
//  SmARt
//
//  Created by MacBook on 23.03.21.
//

import Foundation
import UIKit
import SwiftUI
import Combine

class BaseViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    @Published var loadingProgress = Progress.none
    
    var loadingView = LoadingViewWithProgressBar()
    var proposalForInteractionMessage = InteractionMessage()
    var loadingViewContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        $loadingProgress
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {_ in}, receiveValue: { [unowned self] in
                switch $0 {
                case .started: addLoadingView()
                case .value(let progress): loadingView.updateProgress(CGFloat(progress))
                case .finished: loadingViewContainer.removeFromSuperview()
                default: break
                }})
            .store(in: &cancellables)
    }
    
    func addProposalForInteractionMessage(withTitle title: String) {
        proposalForInteractionMessage.message = title
        view.addSubview(proposalForInteractionMessage)
        proposalForInteractionMessage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            proposalForInteractionMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            proposalForInteractionMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func removeProposalForInteractionMessage() {
        proposalForInteractionMessage.removeFromSuperview()
    }
    
    func addLoadingView() {
        loadingView.text = "Fetching Media Content"
        loadingViewContainer = UIView()
        loadingViewContainer.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        view.addSubview(loadingViewContainer)
        loadingViewContainer.fillSuperview()
        loadingViewContainer.addSubview(loadingView)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

//
//  
//  LoadingView.swift
//  CaixaEletronico
//
//  Created by Marcelo Simim Santos on 1/12/23.
//
//

import Foundation
import Lottie
import UIKit

protocol LoadingViewProtocol {
    func startAnimating()
    func stopAnimating()
}

final class LoadingView: UIView, LoadingViewProtocol {
    private lazy var animation: LottieAnimationView = {
        let animation = LottieAnimationView(asset: "money-loading")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.animationSpeed = 2
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        addViews()
    }

    private func addViews() {
        addSubview(animation )
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            animation.centerXAnchor.constraint(equalTo: centerXAnchor),
            animation.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func startAnimating() {
        animation.play()
    }

    func stopAnimating() {
        animation.stop()
    }
}

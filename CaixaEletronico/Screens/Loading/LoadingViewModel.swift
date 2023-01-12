//
//  
//  LoadingViewModel.swift
//  CaixaEletronico
//
//  Created by Marcelo Simim Santos on 1/12/23.
//
//
import Foundation

protocol LoadingViewModelProtocol {
    var didFinishCounting: (() -> ()) { get set }

    func startCounting()
}

final class LoadingViewModel: LoadingViewModelProtocol {
    var didFinishCounting: (() -> ()) = { }

    func startCounting() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.didFinishCounting()
        }
    }
}

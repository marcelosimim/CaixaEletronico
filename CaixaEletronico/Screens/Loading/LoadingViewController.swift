//
//  
//  LoadingViewController.swift
//  CaixaEletronico
//
//  Created by Marcelo Simim Santos on 1/12/23.
//
//
import UIKit

class LoadingViewController: UIViewController {
    private lazy var customView: LoadingViewProtocol = LoadingView()
    private lazy var viewModel: LoadingViewModelProtocol = LoadingViewModel()
    private let value: Int

    init(value: Int) {
        self.value = value
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelBinds()
        setupNavigationBar()
        customView.startAnimating()
        viewModel.startCounting()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        customView.stopAnimating()
    }

    override func loadView() {
        super.loadView()
        view = customView as? UIView
    }

    private func viewModelBinds() {
        viewModel.didFinishCounting = { [weak self] in
            guard let self else { return }
            self.navigationController?.pushViewController(ResultViewController(value: self.value), animated: true)
        }
    }

    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
    }
}

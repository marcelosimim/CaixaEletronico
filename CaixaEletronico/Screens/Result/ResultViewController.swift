//
//  
//  ResultViewController.swift
//  CaixaEletronico
//
//  Created by Marcelo Simim Santos on 1/12/23.
//
//
import UIKit

class ResultViewController: UIViewController {
    private lazy var customView: ResultViewProtocol = ResultView()
    private lazy var viewModel: ResultViewModelProtocol = ResultViewModel()
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
        title = "Saque para R$\(value) reais"
        setupNavigationBar()
        viewModelBinds()
        viewModel.calculateNotes(value)
    }

    override func loadView() {
        super.loadView()
        view = customView as? UIView
        customView.notesCollectionView.delegate = self
        customView.notesCollectionView.dataSource = self
    }

    private func viewModelBinds() {
        viewModel.didFinishShowing = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }

        viewModel.didFinishWithDrawSuccess = {
            self.customView.notesCollectionView.reloadData()
        }

        viewModel.didFinishWithDrawFailure = { title, message in
            print(title, message)
        }
    }

    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
    }
}

extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.notes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewCell.identifier, for: indexPath) as? NoteCollectionViewCell else { fatalError() }
        let note = viewModel.notes[indexPath.row]
        cell.configure(note)
        return cell
    }
}

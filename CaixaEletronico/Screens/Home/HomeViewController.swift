//
//  
//  HomeViewController.swift
//  CaixaEletronico
//
//  Created by Marcelo Simim Santos on 1/12/23.
//
//
import UIKit

class HomeViewController: UIViewController {
    private lazy var customView: HomeViewProtocol = HomeView()
    private lazy var viewModel: HomeViewModelProtocol = HomeViewModel()
    private var timerForShowScrollIndicator: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Caixa eletrônico"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customView.clean()
        viewModelBinds()
        viewModel.checkAvailableNotes()
        startTimerForShowScrollIndicator()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timerForShowScrollIndicator?.invalidate()
    }

    override func loadView() {
        super.loadView()
        view = customView as? UIView
        customView.delegate = self
        customView.notesCollectionView.delegate = self
        customView.notesCollectionView.dataSource = self
    }

    private func viewModelBinds() {
        viewModel.didFinishCheckingNotes = { [weak self] in
            self?.customView.notesCollectionView.reloadData()
        }
    }

    private func startTimerForShowScrollIndicator() {
       timerForShowScrollIndicator = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.showScrollIndicatorsInCollectionView), userInfo: nil, repeats: true)
    }

    @objc func showScrollIndicatorsInCollectionView() {
       UIView.animate(withDuration: 0.0001) { [weak self] in
           self?.customView.notesCollectionView.flashScrollIndicators()
       }
    }
}

extension HomeViewController: HomeViewDelegate {
    func didTapWithDraw(_ value: String) {
        guard let intValue = Int(value) else { return }
        navigationController?.pushViewController(LoadingViewController(value: intValue), animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

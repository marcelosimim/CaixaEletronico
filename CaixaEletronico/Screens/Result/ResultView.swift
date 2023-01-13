//
//  
//  ResultView.swift
//  CaixaEletronico
//
//  Created by Marcelo Simim Santos on 1/12/23.
//
//

import Foundation
import UIKit

protocol ResultViewProtocol {
    var notesCollectionView: UICollectionView { get set }
}

final class ResultView: UIView, ResultViewProtocol {
    lazy var notesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 75)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(NoteCollectionViewCell.self, forCellWithReuseIdentifier: NoteCollectionViewCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        addViews()
    }

    private func addViews() {
        addSubview(notesCollectionView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            notesCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            notesCollectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            notesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            notesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -64)
        ])
    }
}

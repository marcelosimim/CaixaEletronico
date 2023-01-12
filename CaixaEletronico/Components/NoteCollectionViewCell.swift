//
//  
//  NoteCollectionViewCell.swift
//  CaixaEletronico
//
//  Created by Marcelo Simim Santos on 1/12/23.
//
//

import UIKit

class NoteCollectionViewCell: UICollectionViewCell {
    static let identifier = "\(NoteCollectionViewCell.self)"

    private lazy var noteImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        addViews()
    }

    private func addViews() {
        addSubview(noteImage)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            noteImage.topAnchor.constraint(equalTo: topAnchor),
            noteImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            noteImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            noteImage.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func configure(_ model: NoteType) {
        noteImage.image = model.image
    }
}


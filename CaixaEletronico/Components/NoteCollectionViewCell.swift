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

    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        addViews()
    }

    private func addViews() {
        addSubview(noteImage)
        addSubview(quantityLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            noteImage.topAnchor.constraint(equalTo: topAnchor),
            noteImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            noteImage.heightAnchor.constraint(equalToConstant: 60),

            quantityLabel.topAnchor.constraint(equalTo: noteImage.bottomAnchor, constant: 2),
            quantityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            quantityLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            quantityLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func configure(_ model: AvailableNotes) {
        noteImage.image = model.note.image
        quantityLabel.text = "Quantidade disponível: \(model.quantity)"
    }

    func configure(_ model: NoteType) {
        noteImage.image = model.image
    }
}


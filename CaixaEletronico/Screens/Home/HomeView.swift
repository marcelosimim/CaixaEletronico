//
//  
//  HomeView.swift
//  CaixaEletronico
//
//  Created by Marcelo Simim Santos on 1/12/23.
//
//

import Foundation
import UIKit

protocol HomeViewDelegate: AnyObject {
    func didTapWithDraw(_ value: String)
}

protocol HomeViewProtocol {
    var delegate: HomeViewDelegate? { get set }
    var notesCollectionView: UICollectionView { get set }

    func clean()
}

final class HomeView: UIView, HomeViewProtocol {
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Bem-vindo ao caixa eletrônico!
        Nós temos as notas abaixo disponíveis para saque.
        """
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var notesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 75)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(NoteCollectionViewCell.self, forCellWithReuseIdentifier: NoteCollectionViewCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    private lazy var inputTextField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.keyboardType = .numberPad
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()

    private lazy var withdrawButton: UIButton = {
        let button = UIButton()
        button.setTitle("SACAR", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.addTarget(self, action: #selector(didTapWithDraw), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var delegate: HomeViewDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        addViews()
    }

    private func addViews() {
        addSubview(welcomeLabel)
        addSubview(notesCollectionView)
        addSubview(inputTextField)
        addSubview(withdrawButton)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            welcomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            welcomeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            notesCollectionView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 32),
            notesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            notesCollectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            notesCollectionView.bottomAnchor.constraint(equalTo: inputTextField.topAnchor, constant: -32),

            inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            inputTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64),
            inputTextField.centerXAnchor.constraint(equalTo: centerXAnchor),

            withdrawButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64),
            withdrawButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            withdrawButton.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 32),
        ])
    }

    @objc private func didTapWithDraw() {
        guard let text = inputTextField.text else { return }
        delegate?.didTapWithDraw(text)
    }

    func clean() {
        inputTextField.text = ""
    }
}

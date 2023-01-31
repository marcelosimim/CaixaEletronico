//
//  
//  HomeViewModel.swift
//  CaixaEletronico
//
//  Created by Marcelo Simim Santos on 1/12/23.
//
//
import Foundation

protocol HomeViewModelProtocol {
    var didFinishCheckingNotes: (() -> ()) { get set }
    var notes: [AvailableNotes] { get }

    func checkAvailableNotes()
}

final class HomeViewModel: HomeViewModelProtocol {
    var didFinishCheckingNotes: (() -> ()) = { }
    var notes: [AvailableNotes] = []

    func checkAvailableNotes() {
        notes = []
        for availableNote in TellerMachine.availableNotes {
            if availableNote.quantity > 0 {
                notes.append(availableNote)
            }
        }

        didFinishCheckingNotes()
    }
}

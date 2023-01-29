//
//  TellerMachine.swift
//  CaixaEletronico
//
//  Created by Marcelo Simim Santos on 1/16/23.
//

import Foundation

class TellerMachine {
    static var availableNotes: [AvailableNotes] = []

    static func fillTellerMachine() {
        availableNotes = [AvailableNotes(note: .fifty, quantity: 15), AvailableNotes(note: .ten, quantity: 15), AvailableNotes(note: .five, quantity: 15), AvailableNotes(note: .two, quantity: 15)]
    }

    static func decreaseAmount(note: NoteType, quantity: Int = 1) {
        for i in 0...availableNotes.count-1 {
            if availableNotes[i].note.rawValue == note.rawValue {
                availableNotes[i].quantity -= quantity
            }
        }
    }
}

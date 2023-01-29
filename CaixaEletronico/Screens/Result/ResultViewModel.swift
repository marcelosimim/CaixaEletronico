//
//  
//  ResultViewModel.swift
//  CaixaEletronico
//
//  Created by Marcelo Simim Santos on 1/12/23.
//
//
import Foundation

protocol ResultViewModelProtocol {
    var didFinishShowing: (() -> ()) { get set }
    var didFinishWithDrawSuccess: (() -> ()) { get set }
    var didFinishWithDrawFailure: ((String, String) -> ()) { get set }
    var notes: [NoteType] { get }

    func calculateNotes(_ value: Int)
}

final class ResultViewModel: ResultViewModelProtocol {

    var didFinishShowing: (() -> ()) = { }
    var didFinishWithDrawSuccess: (() -> ()) = { }
    var didFinishWithDrawFailure: ((String, String) -> ()) = { _, _ in }
    var notes: [NoteType] = []
    private var notesForWithDraw: [Int] = []
    private var availableNoteTypes: [NoteType] = []
    private var amountOfNotesAvailable = TellerMachine.availableNotes

    init() {
        fillAvailableNotes()
    }

    func calculateNotes(_ value: Int) {
        let isPossibleToWithdraw = getPossibilidades(balance: value)

        if isPossibleToWithdraw {
            withdraw()
        } else {
            didFinishWithDrawFailure("Não foi possível realizar o saque.", "As notas disponíveis não são suficientes para o valor solicitado.")
        }

        startCounting()
    }

    private func getPossibilidades(balance: Int) -> Bool {
        if balance == 0 {
            return true
        }
        if !hasNotesAvailable() { return false }

        for note in availableNoteTypes where note.rawValue <= balance {
            let result = balance - note.rawValue
            if result >= 0, isNoteAvailable(note), getPossibilidades(balance: result) {
                notesForWithDraw.append(note.rawValue)
                return true

            }
        }

        return false
    }

    private func isNoteAvailable(_ note: NoteType) -> Bool {
        for availableNote in amountOfNotesAvailable {
            if availableNote.note.rawValue == note.rawValue {
                if availableNote.quantity > 0 {
                    removeFromAmountOfNotesAvailable(note: note)
                    return true
                } else { return false }
            }
        }
        return false
    }

    private func hasNotesAvailable() -> Bool {
        var isAllNotesAvailable = false

        for available in amountOfNotesAvailable {
            isAllNotesAvailable = available.quantity > 0
        }

        return isAllNotesAvailable
    }

    private func removeFromAmountOfNotesAvailable(note: NoteType, quantity: Int = 1) {
        for i in 0...amountOfNotesAvailable.count-1 {
            let currentNote = amountOfNotesAvailable[i].note

            if currentNote.rawValue == note.rawValue {
                amountOfNotesAvailable[i].quantity -= quantity
            }
        }
    }

    private func withdraw() {
        getFromTellerMachine()
        showNotes()
    }

    private func showNotes() {
        for noteValue in notesForWithDraw {
            guard let note = NoteType(rawValue: noteValue) else { return }
            notes.append(note)
        }
    }

   private func getFromTellerMachine() {
       for noteValue in notesForWithDraw {
           guard let note = NoteType(rawValue: noteValue) else { return }
           TellerMachine.decreaseAmount(note: note)
       }

       didFinishWithDrawSuccess()
    }

    private func startCounting() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.didFinishShowing()
        }
    }

    private func fillAvailableNotes() {
        let allCases = NoteType.allCases
        allCases.forEach { note in
            availableNoteTypes.append(note)
        }
        availableNoteTypes.sort { $0.rawValue > $1.rawValue }
    }
}

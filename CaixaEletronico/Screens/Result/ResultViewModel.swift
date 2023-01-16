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
    private var availableNotes: [Int] = []

    init() {
        fillAvailableNotes()
    }

    func calculateNotes(_ value: Int) {
        let numberSplitted = separateUnits(value)
        var quantityOfNotes: [Int] = Array(repeating: 0, count: availableNotes.count)

        for digit in numberSplitted {
            var notesToTry = availableNotes
            notesForWithDraw = getNotes(digit, noteToTry: notesToTry[0])

            if isWithDrawCompleted(digit) {
                quantityOfNotes = addNotes(currentNotes: quantityOfNotes, notesToBeAdded: notesForWithDraw)
            } else {
                notesToTry.remove(at: 0)
                while hasNotesToTry(notesToTry) && !isWithDrawCompleted(digit) {
                    notesForWithDraw = getNotes(digit, noteToTry: notesToTry[0])
                    notesToTry.remove(at: 0)
                }
                quantityOfNotes = addNotes(currentNotes: quantityOfNotes, notesToBeAdded: notesForWithDraw)
            }
        }

        notesForWithDraw = quantityOfNotes
        isWithDrawCompleted(value) ? finishWithDraw() : didFinishWithDrawFailure("Saque impossível.", "As notas disponíveis não são suficientes para o saque solicitado.")
        startCounting()
    }

    private func separateUnits(_ value: Int) -> [Int] {
        let stringValue = "\(value)"
        var numberOfDigits = stringValue.count-1
        var numberSplitted: [Int] = []

        stringValue.forEach { char in
            guard let number = Int("\(char)") else { return }
            numberSplitted.append(number*Int(pow(Double(10), Double(numberOfDigits))))
            numberOfDigits -= 1
        }

        return numberSplitted
    }

    private func addNotes(currentNotes: [Int], notesToBeAdded: [Int]) -> [Int] {
        var finalNotes: [Int] = Array(repeating: 0, count: notesToBeAdded.count)

        for i in 0...notesToBeAdded.count-1 {
            finalNotes[i] = currentNotes[i] + notesToBeAdded[i]
        }

        return finalNotes
    }

    private func getNotes(_ value: Int, noteToTry: Int) -> [Int] {
        var needValue = value
        var notesToReturn: [Int] = []

        availableNotes.forEach { currentNote in
            if currentNote <= noteToTry {
                let numberOfNotes = divideByX(value: needValue, x: currentNote)
                notesToReturn.append(numberOfNotes)

                let currentValue = numberOfNotes * currentNote
                let stillMissing = needValue - currentValue

                if stillMissing >= 0 {
                    needValue -= currentValue
                } else {
                    needValue = 0
                }
            } else {
                notesToReturn.append(0)
            }
        }

        return notesToReturn
    }

    private func isWithDrawCompleted(_ value: Int) -> Bool {
        var withDraw = 0
        for i in 0...availableNotes.count-1 {
            withDraw += (availableNotes[i] * notesForWithDraw[i])
        }

        return withDraw == value
    }

    private func hasNotesToTry(_ notestoTry: [Int]) -> Bool {
        notestoTry.count > 0
    }

    private func divideByX(value: Int, x: Int) -> Int {
        Int(value/x)
    }

    private func finishWithDraw() {
        if isAvailableOnTellerMachine(notes: notesForWithDraw) {
            showNotes()
            getFromTellerMachine(notes: notesForWithDraw)
        } else {
            didFinishWithDrawFailure("Saque impossível.", "As notas disponíveis não são suficientes para o saque solicitado.")
        }
    }

    func isAvailableOnTellerMachine(notes: [Int]) -> Bool {
        for i in 0...notes.count-1 {
            if notes[i] > TellerMachine.availableNotes[i].quantity {
                return false
            }
        }
        return true
    }

    private func showNotes() {
        for i in 0...availableNotes.count-1 {
            guard let note = NoteType(rawValue: availableNotes[i]) else { return }
            for _ in 0..<notesForWithDraw[i] {
                notes.append(note)
            }
        }
    }

    private func getFromTellerMachine(notes: [Int]) {
        for i in 0...notes.count-1 {
            print(TellerMachine.availableNotes[i].quantity, notes[i])
            TellerMachine.availableNotes[i].quantity -= notes[i]

        }

        didFinishWithDrawSuccess()
    }

    private func fillAvailableNotes() {
        let allCases = NoteType.allCases
        allCases.forEach { note in
            availableNotes.append(note.rawValue)
        }
        availableNotes.sort { $0 > $1 }
    }

    private func startCounting() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.didFinishShowing()
        }
    }
}

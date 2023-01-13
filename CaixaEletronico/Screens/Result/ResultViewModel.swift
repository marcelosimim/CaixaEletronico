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
    private var possibilities: [Int] = []

    init() {
        fillPossitilities()
    }

    func calculateNotes(_ value: Int) {
        var notesToTry = possibilities

        notesForWithDraw = getNotes(value, noteToTry: notesToTry[0])

        if isWithDrawCompleted(value) {
            finishWithDraw()
            startCounting()
            return
        }

        notesToTry.remove(at: 0)

        while hasNotesToTry(notesToTry) && !isWithDrawCompleted(value) {
            notesForWithDraw = getNotes(value, noteToTry: notesToTry[0])
            notesToTry.remove(at: 0)
        }

        isWithDrawCompleted(value) ? finishWithDraw() : didFinishWithDrawFailure("Saque impossível.", "As notas disponíveis não são suficientes para o saque solicitado.")
        startCounting()
    }

    private func getNotes(_ value: Int, noteToTry: Int) -> [Int] {
        var needValue = value
        var notesToReturn: [Int] = []
        possibilities.forEach { currentNote in
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
        for i in 0...possibilities.count-1 {
            withDraw += (possibilities[i] * notesForWithDraw[i])
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
        for i in 0...possibilities.count-1 {
            guard let note = NoteType(rawValue: possibilities[i]) else { return }
            for _ in 0..<notesForWithDraw[i] {
                notes.append(note)
            }
        }
        didFinishWithDrawSuccess()
    }

    private func fillPossitilities() {
        let allCases = NoteType.allCases
        allCases.forEach { note in
            possibilities.append(note.rawValue)
        }
        possibilities.sort { $0 > $1 }
    }

    private func startCounting() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.didFinishShowing()
        }
    }
}

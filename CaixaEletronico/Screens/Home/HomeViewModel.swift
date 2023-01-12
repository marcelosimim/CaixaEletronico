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
    var notes: [NoteType] { get }
}

final class HomeViewModel: HomeViewModelProtocol {
    var notes: [NoteType] = NoteType.allCases
}

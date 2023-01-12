//
//  NoteType.swift
//  CaixaEletronico
//
//  Created by Marcelo Simim Santos on 1/12/23.
//

import Foundation
import UIKit

enum NoteType: CaseIterable {
    case two
    case five
    case ten
    case fifty

    var image: UIImage {
        switch self {
        case .two:
            return .note2
        case .five:
            return .note5
        case .ten:
            return .note10
        case .fifty:
            return .note50
        }
    }
}

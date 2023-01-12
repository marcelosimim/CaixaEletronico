//
//  
//  UIImage.swift
//  CaixaEletronico
//
//  Created by Marcelo Simim Santos on 1/12/23.
//
//

import UIKit

extension UIImage {
    static func generateImage(_ name: String) -> UIImage {
        UIImage(named: name) ?? UIImage(systemName: "xmark.octagon.fill")!
    }

    static var note2: UIImage { generateImage("2_back") }
    static var note5: UIImage { generateImage("5_back") }
    static var note10: UIImage { generateImage("10_back") }
    static var note50: UIImage { generateImage("50_back") }
}

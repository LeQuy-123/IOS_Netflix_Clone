//
//  Extensions.swift
//  Netflix clone
//
//  Created by mac on 14/7/24.
//

import Foundation

extension String {
    func capitalizeFristLetter() -> String{
        return self.prefix(1).uppercased() + self.dropFirst().lowercased()
    }
}

//
//  Text.swift
//  GuessTheLogoGame
//
//  Created by Pankaj Singh on 10/04/21.
//

import Foundation

struct Text {
    var text: String = ""
    
    init(text: String) {
        self.text = text
    }
}

struct Logo: Codable {
    
    let imgUrl: String
    let name: String
}

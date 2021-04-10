//
//  GameModel.swift
//  GuessTheLogoGame
//
//  Created by Pankaj Singh on 10/04/21.
//

import Foundation

enum GameModelPO {
    case timeUpdate(Int)
    case score(Int)
}

class GameModel {
    var logos: [Logo] = []
    var currentLogo: Logo!
    var inputFields: [Text] = []
    var letterFields: [Text] = []
    var timer: Timer?
    var isPlaying: Bool = true
    var propertyObserver: ((GameModelPO) -> Void)?
    var currentLevel: Int = 1
    var currentTime: Int = 0
    var updatedTime: Int = 0
    
    var indexOfFirstUnfilledInputField: Int {
        return inputFields.firstIndex { (text) -> Bool in
            return text.text.isEmpty
        }!
    }
    
    var indexOfFirstUnfilledLetterField: Int {
        return letterFields.firstIndex { (text) -> Bool in
            return text.text.isEmpty
        }!
    }
    
    init(level: Int) {
        logos = try! Helper.getData()
        for i in 0...logos.count {
            if i+1 == level {
                currentLevel = i + 1
                currentLogo = logos[i]
                break
            }
        }
    }
    
    func setupNewGame() {
        self.inputFields = Array(repeating: Text(text: ""), count: currentLogo.name.count)
        self.letterFields = []
        let alphabet: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        var availableTiles = [String]()
        for _ in (currentLogo.name.count)..<12 {
            let rand = Int(arc4random_uniform(26))
            availableTiles.append(alphabet[rand])
        }
        
        for str in currentLogo.name {
            self.letterFields.append(Text(text: String(str)))
        }
        
        for str in availableTiles {
            self.letterFields.append(Text(text: str))
        }
        self.letterFields = self.letterFields.shuffled()
        
        self.timer?.invalidate()
        self.timer = nil
        self.updatedTime = self.currentTime
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.updatedTime += 1
            weakSelf.propertyObserver?(.timeUpdate(weakSelf.updatedTime))
        })
    }
    
    
    func checkIfSuccessfulCompletion() -> Bool {
        let array = self.inputFields.filter { (text) -> Bool in
            return text.text.isEmpty
        }
        if array.count == 0 {
            var ouptupStr = ""
            for str in self.inputFields {
                ouptupStr.append(str.text)
            }
            if ouptupStr == self.currentLogo.name {
                self.timer?.invalidate()
                self.timer = nil
                return true
            }
        }
        return false
    }
}

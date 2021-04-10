//
//  TextCVC.swift
//  GuessTheLogoGame
//
//  Created by Pankaj Singh on 10/04/21.
//

import UIKit

class TextCVC: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: Text! {
        didSet {
            self.textLabel.text = model.text
            if model.text.isEmpty {
                self.contentView.backgroundColor = .gray
            } else {
                self.contentView.backgroundColor = .green
            }
        }
    }
    
}

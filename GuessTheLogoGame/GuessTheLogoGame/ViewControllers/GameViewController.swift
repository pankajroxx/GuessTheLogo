//
//  ViewController.swift
//  GuessTheLogoGame
//
//  Created by Pankaj Singh on 10/04/21.
//

import UIKit

class GameViewController: UIViewController {
    
    
    @IBOutlet weak var lettersCollectionView: UICollectionView!
    @IBOutlet weak var inputCollectionView: UICollectionView!
    @IBOutlet weak var logoImageVw: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var gameModel = GameModel(level: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        gameModel.setupNewGame()
        gameModel.propertyObserver = { [weak self] (state) in
            guard let weakSelf = self else {
                return
            }
            switch state {
            case .timeUpdate(let x):
                weakSelf.timeLabel.text = "Time \(x) s"
            case .score(_):
                break
            }
        }
        inputCollectionView.register(UINib(nibName:"TextCVC", bundle: nil), forCellWithReuseIdentifier:"TextCVC")
        lettersCollectionView.register(UINib(nibName:"TextCVC", bundle: nil), forCellWithReuseIdentifier:"TextCVC")
        
        downloadImage()
    }
    
    private func downloadImage() {
        DispatchQueue.global().async { [weak self] in
            if let str = self?.gameModel.currentLogo.imgUrl, let url = URL(string: str), let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self?.logoImageVw.image = UIImage(data: data)
                }
            }
        }
    }
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let coll = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCVC", for: indexPath) as! TextCVC
        if collectionView == inputCollectionView {
            coll.model = gameModel.inputFields[indexPath.row]
        } else {
            coll.model = gameModel.letterFields[indexPath.row]
        }
        return coll
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == inputCollectionView {
            return gameModel.inputFields.count
        } else {
            return gameModel.letterFields.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == inputCollectionView {
            let index = gameModel.indexOfFirstUnfilledLetterField
            self.gameModel.letterFields[index] = self.gameModel.inputFields[indexPath.row]
            self.gameModel.inputFields[indexPath.row] = Text(text: "")
        } else {
            let index = gameModel.indexOfFirstUnfilledInputField
            self.gameModel.inputFields[index] = self.gameModel.letterFields[indexPath.row]
            self.gameModel.letterFields[indexPath.row] = Text(text: "")
        }
        inputCollectionView.reloadData()
        lettersCollectionView.reloadData()
        
        if gameModel.checkIfSuccessfulCompletion() {
            let controler = UIAlertController(title: "Successful completion score \(1000/gameModel.updatedTime)", message: nil, preferredStyle: .alert)

            controler.addAction(UIAlertAction(title: "Restart Game", style: .default, handler: { (action) in
                self.gameModel.setupNewGame()
                self.inputCollectionView.reloadData()
                self.lettersCollectionView.reloadData()
            }))
            controler.addAction(UIAlertAction(title: "Procce to next level", style: .default, handler: { (action) in
                let vm = GameModel(level: self.gameModel.currentLevel+1)
                vm.propertyObserver = self.gameModel.propertyObserver
                self.gameModel = vm
                self.gameModel.setupNewGame()
                self.downloadImage()
                self.inputCollectionView.reloadData()
                self.lettersCollectionView.reloadData()
            }))
            
            self.present(controler, animated: true, completion: nil)
        }
    }
}

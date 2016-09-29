//
//  ViewController.swift
//  memory_game_sm
//
//  Created by RBT on 9/25/16.
//  Copyright © 2016 RBT. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var playerName:String = "";
    
    
    let gameController = MemoryGame()
    var timer:NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        playerName = NSUserDefaults.standardUserDefaults().stringForKey("pName")!;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
    
    

    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameController.numberOfCards > 0 ? gameController.numberOfCards : 16
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCell", forIndexPath: indexPath) as! CardCVC
        cell.showCard(false, animted: false)
        
        guard let card = gameController.cardAtIndex(indexPath.item) else { return cell }
        cell.card = card
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CardCVC
        
        if cell.shown { return }
        gameController.didSelectCard(cell.card)
        
        collectionView.deselectItemAtIndexPath(indexPath, animated:true)
    }

    
    
}


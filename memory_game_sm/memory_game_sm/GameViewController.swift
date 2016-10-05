//
//  ViewController.swift
//  memory_game_sm
//
//  Created by RBT on 9/25/16.
//  Copyright © 2016 RBT. All rights reserved.
//

import UIKit

// Swift 3 has rounding feature allready implemented :(
extension Float {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return round(self * divisor) / divisor
    }
}

class GameViewController: UIViewController, MemoryGameDelegate, passModelReferenceToSvcDelegate {// UICollectionViewDelegate, UICollectionViewDataSource, MemoryGameDelegate {

    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startGame: UIButton!
    @IBOutlet weak var clickCount: UILabel!
    
    var playerName:String = "";
    let file = "score.txt"
    let gameModel = MemoryGame()                   // MemoryGame Model instance
    var timer:NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        playerName = NSUserDefaults.standardUserDefaults().stringForKey("pName")!;
        
        // pass reference of class that will use delegate metods
        gameModel.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    func getGameModel() -> MemoryGame{
        return gameModel
    }
    
    // pass GameViewController reference to destination -> ScoreViewController | This is part of delegate initialization
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? ScoreViewController {
            destinationViewController.delegate = self
        }
    }
    
    // ================================================= UI Delegate Metodes ========================================================
    // UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameModel.numberOfCards > 0 ? gameModel.numberOfCards : 16
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCell", forIndexPath: indexPath) as! CardCVC
        cell.showCard(false, animted: false)
        
        guard let card = gameModel.cardAtIndex(indexPath.item) else { return cell }
        cell.card = card
        
        return cell
    }
    
    // UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CardCVC
        
        if cell.shown { return }
        gameModel.didSelectCard(cell.card)
        
        collectionView.deselectItemAtIndexPath(indexPath, animated:true)
        clickCount.text = "Click Num : " + String(gameModel.clickCounter);
    }
    
    // ======================================================= END ===================================================================
    
    @IBAction func startGameButton(sender: UIButton) {
        if gameModel.isPlaying {
            resetGame()
            startGame.setTitle(NSLocalizedString("Start Game", comment: "start"), forState: .Normal)
        } else {
            setupNewGame()
            startGame.setTitle(NSLocalizedString("Stop Game", comment: "stop"), forState: .Normal)
        }
    }
    
    
    func resetGame() {
        gameModel.stopGame()
        if timer?.valid == true {
            timer?.invalidate()
            timer = nil
        }
        collectionView.userInteractionEnabled = false
        collectionView.reloadData()
        timerLabel.text = String(format: "%@: ---", NSLocalizedString("TIME", comment: "time"))
        clickCount.text = String(format: "%@: ---", NSLocalizedString("CLICK CNT", comment: "clicks"))
        startGame.setTitle(NSLocalizedString("Play", comment: "play"), forState: .Normal)
    }
    
    func setupNewGame() {
        let cardsData:[UIImage] = MemoryGame.defaultCardImages
        gameModel.newGame(cardsData)
    }
    
    func gameTimerAction() {
        timerLabel.text = String(format: "%@: %.0fs", NSLocalizedString("TIME", comment: "time"), gameModel.elapsedTime)
    }
    
    
    // ================================================= Memory Game delegat metodes ==================================================
    // Memory Game Model delegate metodes
    
    func memoryGameDidStart(game: MemoryGame) {
        collectionView.reloadData()
        collectionView.userInteractionEnabled = true
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GameViewController.gameTimerAction), userInfo: nil, repeats: true)
        
    }
    
    func memoryGame(game: MemoryGame, showCards cards: [Card]) {                        // showCards is just function argument name
        for card in cards {
            guard let index = gameModel.indexForCard(card) else { continue }
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection:0)) as! CardCVC
            cell.showCard(true, animted: true)
        }
    }
    
    func memoryGame(game: MemoryGame, hideCards cards: [Card]) {                        // hideCards is just function argument name
        for card in cards {
            guard let index = gameModel.indexForCard(card) else { continue }
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection:0)) as! CardCVC
            cell.showCard(false, animted: true)
        }
    }
    
    
    func memoryGameDidEnd(game: MemoryGame, elapsedTime: NSTimeInterval) {
        
        // stop timer
        timer?.invalidate()
        
        // get elapsed time and click number
        let elapsedTime = gameModel.elapsedTime
        let clickNumber = gameModel.clickCounter
        
        // Store result in text file
        gameModel.scoreFile = file
        let text:String = playerName + " : " + " Time: " + String(Float(elapsedTime).roundToPlaces(2)) + " | " + " Clicks: " + String(clickNumber)
        
        // Write score to file
        gameModel.appendScoreToFile(textInput: text, fileName: file)
        
        let alertController = UIAlertController(
            title: NSLocalizedString("Game Finished!", comment: "title"),
            message: String(format: "%@ %.2f seconds \n %d Clicks", NSLocalizedString("Game finished in", comment: "message"),  elapsedTime, clickNumber),
            preferredStyle: .Alert) // NSLocalizedString("Click number", comment: "message"),
        
        let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.Default, handler: {
            // action in self.presentViewController(scoreVC, animated: true, completion: nil);
            action in self.performSegueWithIdentifier("scoreViewSegue", sender: self);
            }
        );
        alertController.addAction(okAction);
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    // ======================================================= END ==================================================================
}

//
//  ScoreViewController.swift
//  memory_game_sm
//
//  Created by RBT on 10/1/16.
//  Copyright © 2016 RBT. All rights reserved.
//

import UIKit

protocol passModelReferenceToSvcDelegate{
    func getGameModel() -> MemoryGame
}

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ScoreTableViewDelegate {
    
    var playerName:String = " "
    var playerGameTime:Float = 0.0
    var playerClicNum:Int = 0

    @IBOutlet weak var scoreTableView: UITableView!
    
    // Declare delegate
    var delegate: passModelReferenceToSvcDelegate?
    
    // declare Array of string for storing all results
    var topTenScoresArray:[String] = [String]()
    
    // Declare MemoryGame instance which will get value from GameMemoryController
    var gameModel:MemoryGame = MemoryGame()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameModel = (delegate?.getGameModel())!
        
        // Do any additional setup after loading the view.
        print("ScoreView Loaded! Fill it with data from file!")
        
        // Now I have gameModel ref so all properties are accessible
        topTenScoresArray = gameModel.getTopTenScores()
        
        
        // topTenScoresArray = getTopTenScores()
        //
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topTenScoresArray.count//myarray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("scoreCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = topTenScoresArray[indexPath.item]
        return cell
    }
    

    @IBAction func BackButton(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameViewController = storyboard.instantiateViewControllerWithIdentifier("gameViewController") as! UIViewController
        self.presentViewController(gameViewController, animated: true, completion: nil)
    }
    
    
    // ================================================ ScoreTableViewDelegate ===============================================
    
    func getTopTenScores(game: MemoryGame) -> [String] {
        //print(gameModel.scoreArray[1])
        //return gameModel.scoreArray
        print(game.scoreArray[1])
        return game.scoreArray
    }
    
    
    // =======================================================================================================================
    
}

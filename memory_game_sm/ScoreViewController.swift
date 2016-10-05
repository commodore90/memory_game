//
//  ScoreViewController.swift
//  memory_game_sm
//
//  Created by RBT on 10/1/16.
//  Copyright © 2016 RBT. All rights reserved.
//

import UIKit
import Social
import FBSDKCoreKit
import FBSDKLoginKit.FBSDKLoginButton


protocol passModelReferenceToSvcDelegate{
    func getGameModel() -> MemoryGame
}


class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate , UIApplicationDelegate ,FBSDKLoginButtonDelegate, ScoreTableViewDelegate, facebookAndTwitterShareDelegate {  //FBSDKLoginButtonDelegate
    
    var playerName:String = " "
    var playerGameTime:Float = 0.0
    var playerClicNum:Int = 0
    var selectedRow:Int = 0;
    
    var loginView:FBSDKLoginButton = FBSDKLoginButton()

    @IBOutlet weak var scoreTableView: UITableView!

    @IBOutlet weak var facebookBtn: FBSDKLoginButton!
    
    // Declare delegate
    var delegate: passModelReferenceToSvcDelegate?
    
    // declare Array of string for storing all results
    var topTenScoresArray:[String] = [String]()
    
    // Declare MemoryGame instance which will get value from GameMemoryController
    var gameModel:MemoryGame = MemoryGame()
    
    let tableViewCell: memoryGameTableViewCell = memoryGameTableViewCell();

    override func viewDidLoad() {
        super.viewDidLoad()
        gameModel = (delegate?.getGameModel())!
        
        // Do any additional setup after loading the view.
        print("ScoreView Loaded! Fill it with data from file!")
        
        // Now I have gameModel ref so all properties are accessible
        topTenScoresArray = gameModel.getTopTenScores()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    
    func configureFacebook() {
        facebookBtn.readPermissions = ["public_profile", "email", "user_friends"];
        facebookBtn.delegate = self
    }
    
    // ========================================= FBSDKLoginButton Delegate ===============================================
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large)"]).startWithCompletionHandler { (connection, result, error) -> Void in
            
            let strFirstName: String = (result.objectForKey("first_name") as? String)!
            let strLastName: String = (result.objectForKey("last_name") as? String)!            

            let loginPopup = UIAlertController(title: "Login successful!", message: "You have successfuly logged-in to Facebook as :" + strFirstName + " " + strLastName, preferredStyle: UIAlertControllerStyle.Alert)
            loginPopup.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(loginPopup, animated: true, completion: nil)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        // ivUserProfileImage.image = nil
        // lblName.text = ""
    }
    
    // ========================================= table View delegate methodes ============================================
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topTenScoresArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("scoreCell", forIndexPath: indexPath) as! memoryGameTableViewCell        
        cell.textLabel?.font = UIFont(name:"Avenir", size:10)
        cell.textLabel?.text = topTenScoresArray[indexPath.item]
        // Pass reference of ScoreViewController which has all Delegate methodes(face/twitter) to custom cell class
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
    }
    
    // ===================================================================================================================

    @IBAction func BackButton(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameViewController = storyboard.instantiateViewControllerWithIdentifier("gameViewController") 
        self.presentViewController(gameViewController, animated: true, completion: nil)
    }
    
    
    func shareOnFacebook(tableViewCell: memoryGameTableViewCell) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
        //if true {
        let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Memory Game Result : " + topTenScoresArray[selectedRow])
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func shareOnTwitter(tableViewCell: memoryGameTableViewCell) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("Memory Game Result : " + topTenScoresArray[selectedRow])
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
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

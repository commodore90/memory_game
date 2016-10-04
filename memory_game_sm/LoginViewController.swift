//
//  LoginViewController.swift
//  memory_game_sm
//
//  Created by RBT on 9/25/16.
//  Copyright © 2016 RBT. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var loginAck:Bool = false;
    
    @IBOutlet weak var playerName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Get Player Name and switch to Game view
    @IBAction func enterGame(sender: UIButton!) {
        let pName = playerName.text

        // Check if field is empty
        if(pName!.isEmpty){
            // Display alert message
            displayAlertMessage("Player Name is required");
            return;
        }
        
        // If playerName Text Field is not empty, store Player Name
        NSUserDefaults.standardUserDefaults().setObject(pName, forKey: "pName");
        NSUserDefaults.standardUserDefaults().synchronize();
        
    }
    
    // Methodes
    func displayAlertMessage(Message:String) {
        let loginAlert = UIAlertController(title:"Alert", message:Message, preferredStyle: UIAlertControllerStyle.Alert);
        let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.Default, handler:nil);
        loginAlert.addAction(okAction);
        self.presentViewController(loginAlert, animated: true, completion: nil)
    }
  
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if loginAck {
            print("prepare for segue")
        }
    }

}

//
//  ViewController.swift
//  memory_game_sm
//
//  Created by RBT on 9/25/16.
//  Copyright © 2016 RBT. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    var playerName:String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        playerName = NSUserDefaults.standardUserDefaults().stringForKey("pName")!;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


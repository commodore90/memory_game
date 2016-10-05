//
//  FaceTwitterIntegration.swift
//  memory_game_sm
//
//  Created by RBT on 10/5/16.
//  Copyright © 2016 RBT. All rights reserved.
//

import Foundation
import UIKit

protocol facebookAndTwitterShareDelegate{
    func shareOnFacebook(tableViewCell: memoryGameTableViewCell)
    func shareOnTwitter(tableViewCell: memoryGameTableViewCell)
}

class memoryGameTableViewCell: UITableViewCell{
    
    // declare delegate
    var delegate: facebookAndTwitterShareDelegate?
    
    @IBAction func facebookShare(sender: UIButton) {
        self.delegate?.shareOnFacebook(self)
    }
    
    @IBAction func twiterShare(sender: AnyObject) {
        self.delegate?.shareOnTwitter(self)
    }
}
//
//  Card.swift
//  memory_game_sm
//
//  Created by RBT on 9/27/16.
//  Copyright © 2016 RBT. All rights reserved.
//

import Foundation


import Foundation
import UIKit.UIImage

//class Card : CustomStringConvertible {
class Card {
    
    // Properties
    var id:NSUUID = NSUUID.init()                   // Unique ID for each card
    var shown:Bool = false
    var image:UIImage
    
    // Constructor metodes
    init(image:UIImage) {
        self.image = image
    }
    
    init(card:Card) {
        self.id = card.id.copy() as! NSUUID
        self.shown = card.shown
        self.image = card.image.copy() as! UIImage
    }
    
    func equals(card: Card) -> Bool {
        return card.id.isEqual(id)
    }
}
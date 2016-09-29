//
//  CardCVC.swift
//  memory_game_sm
//
//  Created by RBT on 9/27/16.
//  Copyright © 2016 RBT. All rights reserved.
//

import UIKit.UICollectionViewCell

class CardCVC: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card? {
        didSet {
            guard let card = card else { return }
            frontImageView.image = card.image
        }
    }
    
    private(set) var shown: Bool = false

    func showCard(show: Bool, animted: Bool) {
        frontImageView.hidden = false
        backImageView.hidden = false
        shown = show
        
        if animted {
            if show {
                UIView.transitionFromView(backImageView,
                                          toView: frontImageView,
                                          duration: 0.5,
                                          options: [.TransitionFlipFromRight, .ShowHideTransitionViews],
                                          completion: { (finished: Bool) -> () in
                })
            } else {
                UIView.transitionFromView(frontImageView,
                                          toView: backImageView,
                                          duration: 0.5,
                                          options: [.TransitionFlipFromRight, .ShowHideTransitionViews],
                                          completion:  { (finished: Bool) -> () in
                })
            }
        } else {
            if show {
                bringSubviewToFront(frontImageView)
                backImageView.hidden = true
            } else {
                bringSubviewToFront(backImageView)
                frontImageView.hidden = true
            }
        }
    }
    
    
}

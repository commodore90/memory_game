//
//  MemoryGame.swift
//  memory_game_sm
//
//  Created by RBT on 9/27/16.
//  Copyright © 2016 RBT. All rights reserved.
//

import Foundation
import UIKit.UIImage

// MemoryGameDelegate

protocol MemoryGameDelegate {
    func memoryGameDidStart(game: MemoryGame)
    func memoryGame(game: MemoryGame, showCards cards: [Card])
    func memoryGame(game: MemoryGame, hideCards cards: [Card])
    func memoryGameDidEnd(game: MemoryGame, elapsedTime: NSTimeInterval)
}

protocol ScoreTableViewDelegate {
    func getTopTenScores(game:MemoryGame) -> [String]
}

// ======================================== extensions ======================================

extension Array {
    //Randomizes the order of the array elements
    mutating func shuffle() {
        for _ in 1...self.count {
            self.sortInPlace { (_,_) in arc4random() < arc4random() }
        }
    }
}

extension String {
    func appendLineToURL(fileURL: NSURL) throws {
        try self.stringByAppendingString("\n").appendToURL(fileURL)
    }
    
    func appendToURL(fileURL: NSURL) throws {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        try data.appendToURL(fileURL)
    }
}

extension NSData {
    func appendToURL(fileURL: NSURL) throws {
        if let fileHandle = try? NSFileHandle(forWritingToURL: fileURL) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.writeData(self)
        }
        else {
            writeToURL(fileURL, atomically: false)
        }
    }
}

extension StreamReader : SequenceType {
    func generate() -> AnyGenerator<String> {
        return AnyGenerator {
            return self.nextLine()
        }
    }
}

// =========================================================================================


class MemoryGame {
    
    static var defaultCardImages:[UIImage] = [
        UIImage(named: "brand_1")!,
        UIImage(named: "brand_2")!,
        UIImage(named: "brand_3")!,
        UIImage(named: "brand_4")!,
        UIImage(named: "brand_5")!,
        UIImage(named: "brand_6")!,
        UIImage(named: "brand_7")!,
        UIImage(named: "brand_8")!
    ];
    
    var cards:[Card] = [Card]()                     // Declare array of Card objects whic will be randomized
    
    // Delegate fields
    var delegate: MemoryGameDelegate?               // Declare delegate property
    var scoreDelegate: ScoreTableViewDelegate?
    
    var isPlaying: Bool = false
    var clickCounter:Int = 0                        // Define Click Counter
    private var cardsShown:[Card] = [Card]()
    private var startTime:NSDate?
    
    var scoreArray:[String] = [String]()
    var scoreFile:String = ""
    
    var numberOfCards: Int {
        get {
            return cards.count
        }
    }
    
    var elapsedTime : NSTimeInterval {
        get {
            guard startTime != nil else {           // make soure that startTime != nil
                return -1
            }
            return NSDate().timeIntervalSinceDate(startTime!)
        }
    }
    
    // ================== Methods ==================
    
    func newGame(cardsData:[UIImage]) {
        cards = randomCards(cardsData)
        startTime = NSDate.init()
        isPlaying = true
        delegate?.memoryGameDidStart(self)
        // finishGame()
    }
    
    func didSelectCard(card: Card?) {
        guard let card = card else { return }
        
        delegate?.memoryGame(self, showCards: [card])
        
        if unpairedCardShown() {
            let unpaired = unpairedCard()!
            if card.equals(unpaired) {
                cardsShown.append(card)
            } else {
                let unpairedCard = cardsShown.removeLast()
                
                // Make 1 sec delay and hide images -> hideCards
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.delegate?.memoryGame(self, hideCards:[card, unpairedCard])
                }
            }
            clickCounter = clickCounter + 1;
        } else {
            cardsShown.append(card)
        }
        
        if cardsShown.count == cards.count {                        // if all cards are shown -> finishGame()
            finishGame()
        }
    }
    
    func stopGame() {
        isPlaying = false
        cards.removeAll()
        cardsShown.removeAll()
        startTime = nil
        clickCounter = 0
    }
    
    func cardAtIndex(index: Int) -> Card? {
        if cards.count > index {
            return cards[index]
        } else {
            return nil
        }
    }
    
    func indexForCard(card: Card) -> Int? {
        for index in 0...cards.count-1 {
            if card === cards[index] {
                return index
            }
        }
        return nil
    }
    
    func appendScoreToFile(textInput text:String, fileName file:String) {
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(scoreFile)
            
            do {
                try text.appendLineToURL(path)
            }
            catch {
                print("Could not write to file")
            }
        }
    }
    
    func readAllScoresFroimFileToArray(FilePath path:NSURL, fileName file:String) {
        // Model reads line by line and fill only first 10 entries in ScoreViewController
        var stringPath:String = " "
        var file_1:String = "score"
        var temp:String = " "
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            stringPath = String(NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file).path!)
        }
        
        if let aStreamReader = StreamReader(path: stringPath) {
            defer {
                aStreamReader.close()
            }
            for line in aStreamReader {
                scoreArray.append(line)
                temp = scoreArray[scoreArray.count-1]
                print(temp)
            }
        }
    }
    
    func getTopTenScores() -> [String] {
        var topTen:[String] = [String]()
        var path:NSURL = NSURL()
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(scoreFile)
        }
        readAllScoresFroimFileToArray(FilePath: path, fileName: scoreFile)
        if scoreArray.count <= 10 {
            topTen = scoreArray
        } else {
            for i in (scoreArray.count-1).stride(to: (scoreArray.count-11), by: -1) {
                topTen.append(scoreArray[i])
            }
        }
        
        return topTen
    }
    
    private func finishGame() {
        isPlaying = false
        delegate?.memoryGameDidEnd(self, elapsedTime: elapsedTime)
    }
    
    private func unpairedCardShown() -> Bool {
        return cardsShown.count % 2 != 0
    }
    
    private func unpairedCard() -> Card? {
        let unpairedCard = cardsShown.last
        return unpairedCard
    }
    
    // randomize pairs of cards
    private func randomCards(cardsData:[UIImage]) -> [Card] {
        var cards:[Card] = [Card]()
        for i in 0...cardsData.count-1 {
            let card = Card.init(image: cardsData[i])
            cards.appendContentsOf([card, Card.init(card: card)])           // append pair of cards
        }
        cards.shuffle()
        return cards
    }
}
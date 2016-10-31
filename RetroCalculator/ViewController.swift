//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Денис Трясунов on 10/30/16.
//  Copyright © 2016 Денис Трясунов. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var counterLbl: UILabel!
    var btnSound: AVAudioPlayer!
    
    var runningNum = ""
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Add = "+"
        case Subtract = "-"
        case Empty = "Empty"
    }
    
    var currentOperation = Operation.Empty
    var leftValStr = ""
    var rightValStr = ""
    var result = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wavPath = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: wavPath!)
        
        do {
            try btnSound = AVAudioPlayer.init(contentsOf: soundUrl)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        
        runningNum += "\(sender.tag)"
        counterLbl.text = runningNum
    }
    
    @IBAction func onMultiplyPressed(sender: UIButton) {
        processOperation(operation: .Multiply)
    }
    @IBAction func onDividePressed(sender: UIButton) {
        processOperation(operation: .Divide)
    }
    @IBAction func onAddPressed(sender: UIButton) {
        processOperation(operation: .Add)
    }
    @IBAction func onSubtractPressed(sender: UIButton) {
        processOperation(operation: .Subtract)
    }
    @IBAction func onEqualsPressed(sender: UIButton) {
        processOperation(operation: currentOperation)
    }
    @IBAction func clearPressed(sender: UIButton) {
        playSound()
        
        runningNum = ""
        currentOperation = .Empty
        counterLbl.text = "0"
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }
    
    func processOperation(operation: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {
            
            if runningNum != "" {
                rightValStr = runningNum
                runningNum = ""
                
                switch currentOperation {
                case .Multiply:
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                case .Divide:
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                case .Add:
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                case .Subtract:
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                default:
                    result = "WTF?!"
                }
                
                leftValStr = result
                counterLbl.text = result
            }
            
            currentOperation = operation
            
        } else {
            // operator pressed for 1st time
            leftValStr = runningNum
            runningNum = ""
            currentOperation = operation
        }
    }

}


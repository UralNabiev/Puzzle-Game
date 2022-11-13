//
//  GameVC.swift
//  Puzzle_Game
//
//  Created by O'ral Nabiyev on 05/11/22.
//

import UIKit
import AVFoundation


class GameVC: UIViewController {
    
    @IBOutlet weak var totalMovesLbl: UILabel!
    @IBOutlet var collectionBtn: [UIButton]!
    @IBOutlet weak var recordLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var recordMovesLbl: UILabel!
    @IBOutlet weak var totalMovesTextLbl: UILabel!
    
    
    var player: AVAudioPlayer?
    
    var totalMoves: Int = 0
    var recordTime: String = "00:00"
    var recordMoves: Int = 0
    var numbersCollection: [Int] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    var arr: [Int] = []
    let numbers = 1...15
    var count = 0
    
    var timer: Timer = Timer()
    var countTimer: Int = 0
    var timerCounting: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        playViewDidload()
    }
    
    
    func playViewDidload() {
        totalMovesLbl.text = "\(totalMoves)"
        recordLbl.text = recordTime
        shuffleCollection()
        numbersCollection.shuffle()
        collectionBtn.last?.backgroundColor = .clear
        collectionBtn.last?.setTitle(nil, for: .normal)
        playNoSoundStart()
        recordMovesLbl.text = "\(totalMoves)"

    }
    
    func playSwitchSound() {
        let soundURL = Bundle.main.url(forResource: "btn_tapped", withExtension: "mp3")
        
        do {
            try player = AVAudioPlayer(contentsOf: soundURL!)
        } catch {
            print(error)
        }
        player?.play()
    }
    
    func playNoSoundStart() {
        let soundURL = Bundle.main.url(forResource: "start_game", withExtension: "mp3")

        do {
            try player = AVAudioPlayer(contentsOf: soundURL!)
        } catch {
            print(error)
        }
        player?.play()
    }
    
    func playNoSoundFinish() {
        let soundURL = Bundle.main.url(forResource: "finish_game", withExtension: "mp3")

        do {
            try player = AVAudioPlayer(contentsOf: soundURL!)
        } catch {
            print(error)
        }
        player?.play()
    }
    
    func shuffleCollection() {
        var shuffledNumbers = numbers.shuffled()
        
        for i in collectionBtn {
            if !shuffledNumbers.isEmpty {
                i.setTitle("\(shuffledNumbers[0])", for: .normal)
                shuffledNumbers.removeFirst()
            }
        }
    }

    @IBAction func restartTapped(_ sender: Any) {
        for btn in collectionBtn {
            btn.isEnabled = true
            btn.backgroundColor = .black
        }
        collectionBtn.last?.backgroundColor = .clear
        collectionBtn.last?.setTitle(nil, for: .normal)
        shuffleCollection()
        totalMoves = 0
        totalMovesLbl.text = "\(totalMoves)"
        timerCounting = false
        
        countTimer = 0
        timer.invalidate()
        timerLbl.text = makeTimeString(minutes: 0, seconds: 0)
        timerLbl.textColor = .black

    }
    
    
    @IBAction func collectionTapped(_ sender: UIButton) {
            arr = []
        
            for i in collectionBtn {
            arr.append(i.tag)
                print(arr.count)
            if i.currentTitle == nil {
                if arr.count-1 == sender.tag - 1 || arr.count-1 == sender.tag + 1 || arr.count-1 == sender.tag - 4 || arr.count-1 == sender.tag + 4 {
                    totalMoves += 1
                    
                    print("total moves = ", totalMoves)

                    if totalMoves == 1 {
                        print("total moves in = ", totalMoves)

                        if timerCounting {
                            timerCounting = false
                            timer.invalidate()
                            timerLbl.textColor = .black
                        } else {
                            timerCounting = true
                            timerLbl.textColor = .red
                            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
                        }
                        
                        
                    }
                    totalMovesLbl.text = "\(totalMoves)"
                    i.setTitle(sender.currentTitle, for: .normal)
                    i.backgroundColor = .black
                    sender.backgroundColor = .clear
                    sender.setTitle(nil, for: .normal)
                    playSwitchSound()
                    print("----------------------")
                } else {
                    //playNoSound()
                    print("============")
                }
            }
        }

        count = 0
        for i in collectionBtn {
            if i.currentTitle == "\(i.tag+1)" {
                count += 1
                if count == 15 {
                    
                    for btn in collectionBtn {
                        btn.isEnabled = false
                    }
                    totalMovesLbl.text = "You Win"
                    timerCounting = false
                    timer.invalidate()
                    timerLbl.textColor = .black
                    totalMovesTextLbl.isHidden = true
                    if totalMoves < Int(recordMovesLbl.text!)! || totalMoves == 0 {
                        recordLbl.text = timerLbl.text
                        recordMovesLbl.text = "\(totalMoves)"
                    }
                    playNoSoundFinish()
                    print("FINISH")
                    count = 0
                    
                }
            }
        }
        
    }
    
    @objc func timerCounter() -> Void {
        
        countTimer = countTimer + 1
        let time = secondsToHoursMinutesSecond(seconds: countTimer)
        let timeString = makeTimeString(minutes: time.0, seconds: time.1)
        timerLbl.text = timeString
        
    }
    
    func secondsToHoursMinutesSecond(seconds: Int) -> (Int, Int) {
        return  (((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }

    func makeTimeString(minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
}

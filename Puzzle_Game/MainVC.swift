//
//  MainVC.swift
//  Puzzle_Game
//
//  Created by O'ral Nabiyev on 05/11/22.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func startGameTapped(_ sender: Any) {
        
        let vc = GameVC(nibName: "GameVC", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
        
    }
    

}

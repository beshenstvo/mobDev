//
//  ViewController.swift
//  lesson1
//
//  Created by Rufus on 01.10.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    var count: Int? = 0;
    @IBAction func click(_ sender: UIButton) {
        let randomInt: String? = String(Int.random(in: 1..<7))
        let myImage: UIImage = UIImage(named: randomInt!)!
        image.image = myImage
        myLabel.text = "Cчёт: \(count!+Int(randomInt!)!)"
        count! += Int(randomInt!)!
    }
    
    @IBAction func clear(_ sender: UIButton) {
        count = 0;
        myLabel.text = "Cчёт: 0"
        image.image =  UIImage(named: "0")
    }
}


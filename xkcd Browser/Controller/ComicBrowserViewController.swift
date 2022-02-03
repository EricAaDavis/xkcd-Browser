//
//  ViewController.swift
//  xkcd Browser
//
//  Created by Eric Davis on 31/01/2022.
//

import UIKit

class ComicDetailedViewController: UIViewController {

    @IBOutlet weak var comicImage: UIImageView!
    @IBOutlet weak var comicNumberLabel: UILabel!
    @IBOutlet weak var transcriptLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var comic: Comic?
    
    
}


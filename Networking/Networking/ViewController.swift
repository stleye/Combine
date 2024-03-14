//
//  ViewController.swift
//  Networking
//
//  Created by Sebastian Tleye on 13/03/2024.
//

import UIKit
import Combine



class ViewController: UIViewController {
    
    var fetch1 = Fetch1()
    var fetch2 = Fetch2()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetch2.run()
    }


}


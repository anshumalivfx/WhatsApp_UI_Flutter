//
//  MusicViewController.swift
//  Runner
//
//  Created by Anshumali Karna on 12/01/23.
//

import UIKit

class MusicViewController: UIViewController {
    
    
    private var textFeild = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        textFeild.placeholder = "Enter your Text"
        
        
        self.view.addSubview(textFeild)
        // Do any additional setup after loading the view.
    }
}
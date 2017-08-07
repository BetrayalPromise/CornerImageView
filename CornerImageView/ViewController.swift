//
//  ViewController.swift
//  CornerImageView
//
//  Created by 李阳 on 7/8/2017.
//  Copyright © 2017 qms. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingImageView: CornerImageView = CornerImageView.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100), cornerRadius: 15, cornerPositon: UIRectCorner.allCorners, borderColor: UIColor.blue, borderWidth: 3)
        loadingImageView.image = UIImage.init(named: "test")
        self.view.addSubview(loadingImageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


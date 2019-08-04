//
//  ViewController.swift
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingImageView: CornerImageView = CornerImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100), cornerRadius: 15, cornerPositon: UIRectCorner.allCorners, borderColor: UIColor.blue, borderWidth: 1)
        loadingImageView.image = UIImage(named: "test")
        self.view.addSubview(loadingImageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


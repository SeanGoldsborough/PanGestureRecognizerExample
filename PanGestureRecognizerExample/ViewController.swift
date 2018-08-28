//
//  ViewController.swift
//  PanGestureRecognizerExample
//
//  Created by Sean Goldsborough on 8/28/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var fileViewOrigin: CGPoint!

    @IBOutlet weak var fileImageView: UIImageView!
    @IBOutlet weak var trashImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPanGesture(view: fileImageView)
        fileViewOrigin = fileImageView.frame.origin
    }

    func addPanGesture(view: UIView){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(sender:)))
        view.addGestureRecognizer(pan)
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let fileView = sender.view!
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began, .changed:
            // This enables us to move the file view along with the gesture recognizer
            fileImageView.center = CGPoint(x: fileView.center.x + translation.x, y: fileView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: view)
        case .ended:
            break
        default:
            break
        }
    }

}


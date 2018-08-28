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
        view.bringSubview(toFront: fileImageView)
    }

    func addPanGesture(view: UIView){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(sender:)))
        view.addGestureRecognizer(pan)
    }
    
    // TODO: Refactor
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        
        let fileView = sender.view!
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began, .changed:
            // This enables us to move the file view along with the gesture recognizer
            fileImageView.center = CGPoint(x: fileView.center.x + translation.x, y: fileView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: view)
        case .ended:
            // This fades the file image view out when it intersects with the trash image view
            if fileView.frame.intersects(trashImageView.frame) {
                UIView.animate(withDuration: 0.3, animations: {self.fileImageView.alpha = 0.0})
            } else {
            // This moves the file image view back to the point of origin if
            // it does not intersect with the trash image view
                UIView.animate(withDuration: 0.3, animations: {self.fileImageView.frame.origin = self.fileViewOrigin})
            }
        default:
            break
        }
    }
    
}


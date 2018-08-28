//
//  ViewController.swift
//  PanGestureRecognizerExample
//
//  Created by Sean Goldsborough on 8/28/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var fileViewOrigin: CGPoint!
    var audioPlayer = AVAudioPlayer()

    //@IBOutlet weak var fileImageView: UIImageView!
    weak var newImageView: UIImageView!
    @IBOutlet weak var trashImageView: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        createAudioPlayer()
        createImageView()
    }
    
    func createImageView() {
        let imageName = "file.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        newImageView = imageView
        newImageView.alpha = 1.0
        newImageView.isUserInteractionEnabled = true
        print("self.fileImageView is now: \(newImageView)")
        
        newImageView.frame = CGRect(x: 20, y: 20, width: 128, height: 128)
        
        view.addSubview(newImageView)
        addPanGesture(view: newImageView)
        fileViewOrigin = newImageView.frame.origin
        view.bringSubview(toFront: newImageView)
    }
    
    func createAudioPlayer() {
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "paperThrow", ofType: ".mp3")!))
            audioPlayer.prepareToPlay()
        }
        catch {
            print(error.localizedDescription)
        }
    }

    func addPanGesture(view: UIView){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(sender:)))
        view.addGestureRecognizer(pan)
    }

    @objc func handlePan(sender: UIPanGestureRecognizer) {
        
        var fileView = sender.view!
        
        switch sender.state {
        case .began, .changed:
           moveViewWithPan(fileView: fileView, sender: sender)
        case .ended:
            if fileView.frame.intersects(trashImageView.frame) {
                deleteView(view: fileView)
            } else {
                returnViewToOrigin(view: fileView)
            }
        default:
            break
        }
    }
    
    func moveViewWithPan(fileView: UIView, sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        // This enables us to move the file view along with the gesture recognizer
        newImageView.center = CGPoint(x: fileView.center.x + translation.x, y: fileView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    func returnViewToOrigin(view:UIView) {
        // This moves the file image view back to the point of origin if
        // it does not intersect with the trash image view
        UIView.animate(withDuration: 0.3, animations: {self.newImageView.frame.origin = self.fileViewOrigin})
    }
    
    func deleteView(view: UIView) {
        // This fades the file image view out when it intersects with the trash image view
        UIView.animate(withDuration: 0.3, animations: {self.newImageView.alpha = 0.0})
        audioPlayer.play()
        self.newImageView = nil
        print("self.fileImageView is:\(self.newImageView)")
        createImageView()
    }
}

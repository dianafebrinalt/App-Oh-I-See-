//
//  HomeViewController.swift
//  App Oh I See!
//
//  Created by Diana Febrina Lumbantoruan on 12/07/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var viewTextToSpeech: UIView!
    @IBOutlet weak var viewImageToSpeech: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTextToSpeech.layer.borderWidth = 1
        viewImageToSpeech.layer.borderWidth = 1
        
        viewTextToSpeech.layer.borderColor = UIColor.darkGray.cgColor
        viewImageToSpeech.layer.borderColor = UIColor.darkGray.cgColor
    }
    @IBAction func goToAddText(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "LibraryTextViewController") as! LibraryTextViewController
        let transition = CATransition()
        vc.modalPresentationStyle = .fullScreen
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func goToAddImage(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "LibraryImageViewController") as! LibraryImageViewController
        let transition = CATransition()
        vc.modalPresentationStyle = .fullScreen
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(vc, animated: false, completion: nil)
    }
    
}

//
//  AddDataImage.swift
//  App Oh I See!
//
//  Created by Diana Febrina Lumbantoruan on 13/07/21.
//

import UIKit
import CoreData
import MobileCoreServices

class AddDataImage: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tfTitleDocument: UITextField!
    @IBOutlet weak var imageChoosen: UIImageView!
    
    var mainScreenProtocol : ViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfTitleDocument.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func backToLibrary(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTheData(_ sender: Any) {
        print("Yayyyyyyy!")
        guard let title = tfTitleDocument.text else {
            print("error title")
            return
        }
        
        guard let image = imageChoosen.image?.jpegData(compressionQuality: 20.0) else {
            return
        }
        
        tfTitleDocument.text = ""
        imageChoosen.image = UIImage(systemName: "photo")
        
        DatabaseImageHandler.shared.setImage(title: title, imageData: image)
        mainScreenProtocol?.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        let chooseImage = UIAlertController(title: "Add Image", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let takePhoto = UIAlertAction(
                title: "Take Photo",
                style: .default){(alert) -> Void in
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                self.present(imagePicker, animated: true, completion: {
                })
            }
            chooseImage.addAction(takePhoto)
        }
        
        let pickFromGalery = UIAlertAction(
            title: "Choose Existing",
            style: .default){(alert) -> Void in
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            self.present(imagePicker, animated: true, completion: {
            })
        }
        chooseImage.addAction(pickFromGalery)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        chooseImage.addAction(cancelButton)
        
        chooseImage.view.tintColor = UIColor(red: (0/255.0), green: (77/255.0), blue: (128/255.0), alpha: 1.0)

        let subview = (chooseImage.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.layer.cornerRadius = 1
        subview.backgroundColor = UIColor(red: (177/255.0), green: (185/255.0), blue: (225/255.0), alpha: 1.0)
        
        present(chooseImage, animated: true, completion: nil)
    }
}

extension AddDataImage: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedPhoto = info[.editedImage] as? UIImage else {
            dismiss(animated: true)
            return
        }
        
        self.imageChoosen.image = selectedPhoto
        self.dismiss(animated: true, completion: nil)
    }
}

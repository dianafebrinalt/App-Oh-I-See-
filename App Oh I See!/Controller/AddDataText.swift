//
//  AddDataText.swift
//  App Oh I See!
//
//  Created by Diana Febrina Lumbantoruan on 13/07/21.
//

import UIKit
import CoreData

class AddDataText: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var tfTitleDocument: UITextField!
    @IBOutlet weak var textInput: UITextView!
    
    var mainScreenProtocol : ViewControllerProtocol?
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfTitleDocument.delegate = self
        textInput.delegate = self
    }

    @IBAction func backToTextToSpeech(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveDataTextInput(_ sender: Any) {
        print("Save Save Save Save Save")
        let newDataText = Text(context: context)
        
        newDataText.titleText = tfTitleDocument.text
        newDataText.textInput = textInput.text
        
        do{
            try context.save()
        }
        catch{
            print(error.localizedDescription)
        }
        mainScreenProtocol?.reloadData()
        
        self.dismiss(animated: true, completion: nil)
    }
}

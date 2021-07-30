//
//  LibraryTextViewController.swift
//  App Oh I See!
//
//  Created by Diana Febrina Lumbantoruan on 12/07/21.
//

import UIKit
import CoreData

class LibraryTextViewController: UIViewController {

    @IBOutlet weak var tableViewDataText: UITableView!
    @IBOutlet weak var labelEmpty: UILabel!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var listDataText : [Text] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewDataText.delegate = self
        tableViewDataText.dataSource = self
        
        let nib = UINib(nibName: "DataLibraryCell", bundle: nil)
        tableViewDataText.register(nib, forCellReuseIdentifier: "dataCell")
        
        fetchDataText()
        reloadData()
        
        if !listDataText.isEmpty{
            tableViewDataText.isHidden = false
            labelEmpty.isHidden = true
        }
        else{
            tableViewDataText.isHidden = true
            labelEmpty.isHidden = false
            labelEmpty.text = "There are no document yet.  How about making your own document?"
        }
    }
    
    func fetchDataText() -> [Text] {
        let request: NSFetchRequest<Text> = Text.fetchRequest()
        
        do{
            listDataText = try context.fetch(request)
        }catch {
            print("Error fetching text data")
        }
        return listDataText
    }
    
    @IBAction func backToMenu(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addDataLibraryText(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AddDataText") as! AddDataText
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension LibraryTextViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDataText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! DataLibraryCell
        
        let dataText = listDataText[indexPath.row]
        cell.judulText.text = dataText.titleText
        cell.textImage.image = UIImage(named: "Text")
        cell.tandaPanah.image = UIImage(systemName: "chevron.right")
        
        cell.layer.cornerRadius = 12
        cell.layer.borderWidth = 1
        cell.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 12, dy: 4)
        maskLayer.backgroundColor = UIColor.white.cgColor
        cell.layer.mask = maskLayer
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.beginUpdates()
            
            let dataTextRemove = listDataText[indexPath.row]
            self.context.delete(dataTextRemove)
            fetchDataText()

            do {
                try self.context.save()
            } catch  {
                print("error delete")
            }
            
            if !listDataText.isEmpty{
                tableViewDataText.isHidden = false
                labelEmpty.isHidden = true
            }
            else{
                tableViewDataText.isHidden = true
                labelEmpty.isHidden = false
                labelEmpty.text = "There are no document yet.  How about making your own document?"
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Yeyyyy bisa ke speech text")
        if let vc = storyboard?.instantiateViewController(identifier: "TextToSpeechViewController") as? TextToSpeechViewController {
            vc.detailText = self.listDataText[indexPath.row]
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchDataText()
        tableViewDataText.reloadData()
        if !listDataText.isEmpty{
            tableViewDataText.isHidden = false
            labelEmpty.isHidden = true
        }
        else{
            tableViewDataText.isHidden = true
            labelEmpty.isHidden = false
            labelEmpty.text = "There are no document yet.  How about making your own document?"
        }
    }
}

extension LibraryTextViewController: ViewControllerProtocol{
    func reloadData() {
        listDataText  = fetchDataText()
        tableViewDataText.reloadData()
        if !listDataText.isEmpty{
            tableViewDataText.isHidden = false
            labelEmpty.isHidden = true
        }
        else{
            tableViewDataText.isHidden = true
            labelEmpty.isHidden = false
            labelEmpty.text = "There are no document yet.  How about making your own document?"
        }
    }
}

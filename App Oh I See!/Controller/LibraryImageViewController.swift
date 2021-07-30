//
//  LibraryImageViewController.swift
//  App Oh I See!
//
//  Created by Diana Febrina Lumbantoruan on 13/07/21.
//

import UIKit
import CoreData

class LibraryImageViewController: UIViewController {

    @IBOutlet weak var tableViewSetImage: UITableView!
    @IBOutlet weak var labelEmpty: UILabel!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var listDataImage: [Image] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewSetImage.delegate = self
        tableViewSetImage.dataSource = self
        
        let nib = UINib(nibName: "DataLibraryCell", bundle: nil)
        tableViewSetImage.register(nib, forCellReuseIdentifier: "dataCell")
        
        fetchDataImage()
        reloadData()
        
        if !listDataImage.isEmpty{
            tableViewSetImage.isHidden = false
            labelEmpty.isHidden = true
        }
        else{
            tableViewSetImage.isHidden = true
            labelEmpty.isHidden = false
            labelEmpty.text = "There are no document yet.  How about making your own document?"
        }
    }
    
    func fetchDataImage() -> [Image] {
        let request: NSFetchRequest<Image> = Image.fetchRequest()
        
        do{
            listDataImage = try context.fetch(request)
        }catch {
            print("Error fetching text data")
        }
        return listDataImage
    }
    
    @IBAction func backToMenu(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addDataImage(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AddDataImage") as! AddDataImage
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension LibraryImageViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDataImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! DataLibraryCell
        
        let dataImage = listDataImage[indexPath.row]
        cell.judulText.text = dataImage.titleImage
        cell.textImage.image = UIImage(data: dataImage.imageInput!)
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
            
            let dataTextRemove = listDataImage[indexPath.row]
            self.context.delete(dataTextRemove)
            fetchDataImage()

            do {
                try self.context.save()
            } catch  {
                print("error delete")
            }
            
            if !listDataImage.isEmpty{
                tableViewSetImage.isHidden = false
                labelEmpty.isHidden = true
            }
            else{
                tableViewSetImage.isHidden = true
                labelEmpty.isHidden = false
                labelEmpty.text = "There are no document yet.  How about making your own document?"
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Yeyyyy bisa ke speech image")
        if let vc = storyboard?.instantiateViewController(identifier: "ImageToSpeechViewController") as? ImageToSpeechViewController{
            vc.detailImage = self.listDataImage[indexPath.row]
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchDataImage()
        tableViewSetImage.reloadData()
        
        if !listDataImage.isEmpty{
            tableViewSetImage.isHidden = false
            labelEmpty.isHidden = true
        }
        else{
            tableViewSetImage.isHidden = true
            labelEmpty.isHidden = false
            labelEmpty.text = "There are no document yet.  How about making your own document?"
        }
    }
}

extension LibraryImageViewController: ViewControllerProtocol{
    func reloadData() {
        listDataImage  = fetchDataImage()
        tableViewSetImage.reloadData()
        if !listDataImage.isEmpty{
            tableViewSetImage.isHidden = false
            labelEmpty.isHidden = true
        }
        else{
            tableViewSetImage.isHidden = true
            labelEmpty.isHidden = false
            labelEmpty.text = "There are no document yet.  How about making your own document?"
        }
    }
}

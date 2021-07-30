//
//  ImageHandler.swift
//  App Oh I See!
//
//  Created by Diana Febrina Lumbantoruan on 13/07/21.
//

import Foundation
import UIKit
import CoreData

class DatabaseImageHandler{
    
    static let shared = DatabaseImageHandler()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func setImage(title: String, imageData: Data) {
        let image = Image(context: context)
        image.titleImage = title
        image.imageInput = imageData
        do{
            try context.save()
        }
        catch{
            print(error.localizedDescription)
        }
        
        save()
    }
    
    func save () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

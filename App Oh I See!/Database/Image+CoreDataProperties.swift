//
//  Image+CoreDataProperties.swift
//  App Oh I See!
//
//  Created by Diana Febrina Lumbantoruan on 13/07/21.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var titleImage: String?
    @NSManaged public var imageInput: Data?

}

extension Image : Identifiable {

}

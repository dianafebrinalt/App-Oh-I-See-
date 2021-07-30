//
//  Text+CoreDataProperties.swift
//  App Oh I See!
//
//  Created by Diana Febrina Lumbantoruan on 13/07/21.
//
//

import Foundation
import CoreData


extension Text {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Text> {
        return NSFetchRequest<Text>(entityName: "Text")
    }

    @NSManaged public var textInput: String?
    @NSManaged public var titleText: String?

}

extension Text : Identifiable {

}

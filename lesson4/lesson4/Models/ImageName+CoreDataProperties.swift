//
//  ImageName+CoreDataProperties.swift
//  lesson4
//
//  Created by Rufus on 29.10.2021.
//
//

import Foundation
import CoreData


extension ImageName {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageName> {
        return NSFetchRequest<ImageName>(entityName: "ImageName")
    }

    @NSManaged public var label: String?

}

extension ImageName : Identifiable {

}

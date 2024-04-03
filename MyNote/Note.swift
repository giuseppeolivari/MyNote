//
//  Note.swift
//  MyNote
//
//  Created by Giuseppe Olivari on 31/03/24.
//

import CoreData

@objc(Note)
class Note: NSManagedObject
{
    @NSManaged var id: NSNumber!
    @NSManaged var title: String!
    @NSManaged var testo: String!
    @NSManaged var deletedDate: Date?
}

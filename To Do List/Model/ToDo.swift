//
//  ToDo.swift
//  To Do List
//
//  Created by Konstantin Ryabtsev on 18.02.2022.
//

import UIKit

@objcMembers class ToDo: NSObject {
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    var image: UIImage?
    
    init(
        title: String = "",
        isComplete: Bool = false,
        dueDate: Date = Date(),
        notes: String? = nil,
        image: UIImage? = nil
    ) {
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
        self.image = image
    }
    
    var capitalizedKeys: [String] {
        return keys.map { $0.capitalizedWithSpaces }
    }
    
    var keys: [String] {
        return Mirror(reflecting: self).children.compactMap { $0.label }
    }
    
    var values: [Any?] {
        return Mirror(reflecting: self).children.map { $0.value }
    }
    
    override func copy() -> Any {
        let newToDo = ToDo(
            title: title,
            isComplete: isComplete,
            dueDate: dueDate,
            notes: notes,
            image: image?.copy() as? UIImage)
        
        return newToDo
    }
}

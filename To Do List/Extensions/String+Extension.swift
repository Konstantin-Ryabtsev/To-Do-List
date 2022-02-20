//
//  String+Extension.swift
//  To Do List
//
//  Created by Konstantin Ryabtsev on 18.02.2022.
//

extension String {
    var capitalizedWithSpaces: String {
        let withSpaces = reduce("") { result, character in
            character.isUppercase ? "\(result) \(character)" : "\(result)\(character)"
        }
        
        return withSpaces.capitalized
    }
}

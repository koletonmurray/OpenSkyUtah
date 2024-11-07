//
//  Array+Identifiable.swift
//  OpenSkyUtah
//
//  Created by Koleton Murray on 11/7/24.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching element: Element) -> Int? {
        for index in indices {
            if self[index].id == element.id {
                return index
            }
        }
        
        return nil
    }
}

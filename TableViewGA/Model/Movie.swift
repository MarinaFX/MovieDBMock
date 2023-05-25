//
//  Movie.swift
//  TableViewGA
//
//  Created by Marina De Pazzi on 25/05/23.
//

import Foundation
import UIKit

struct MovieResponse: Decodable {
    var results: [Movie]
}

struct Movie: Decodable, CustomStringConvertible {
    
    var id: Int
    var title: String
    var overview: String
    var voteAverage: Double
    var genres: [String]
    
    var imageCover: UIImage {
        UIImage(named: self.title)!
    }
    
    var description: String {
        return "\(self.id)" + " - " + self.title
    }
}

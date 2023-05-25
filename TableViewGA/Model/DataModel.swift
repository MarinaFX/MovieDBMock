//
//  DataModel.swift
//  TableViewGA
//
//  Created by Marina De Pazzi on 25/05/23.
//

import Foundation

struct DataModel {
    enum JSONReaderError: Error {
        case DataConversionError(Error)
        case FileNotFoundError
    }
    
    enum MovieType: String {
        case popular
        case nowPlaying
    }
    
    static func fetchMovies(from type: MovieType = .popular) throws -> [Movie] {
        if let path = Bundle.main.path(forResource: type.rawValue, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                let movie = try JSONDecoder().decode(MovieResponse.self, from: data)
                    
                return movie.results
            } catch {
                throw JSONReaderError.DataConversionError(error)
            }
        }
        
        throw JSONReaderError.FileNotFoundError
    }
}

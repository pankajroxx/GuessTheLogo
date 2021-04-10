//
//  File.swift
//  GuessTheLogoGame
//
//  Created by Pankaj Singh on 10/04/21.
//

import Foundation

//MARK:- ============================================================== DECODABLE =================================================================

extension Decodable {
    static func fromJSON<T:Decodable>(_ fileName: String, fileExtension: String="json", bundle: Bundle = .main) throws -> T {
        guard let url = bundle.url(forResource: fileName, withExtension: fileExtension) else {
            throw NSError(domain: NSURLErrorDomain, code: NSURLErrorResourceUnavailable)
        }
        let data = try Data(contentsOf: url)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print(error.localizedDescription)
            throw NSError(domain: "Invalid Data", code: 303)
        }
    }
}

class Helper {
    
    static func getData() throws -> [Logo] {
        var logos: [Logo] = []
        do {
            let result = try [Logo].fromJSON("logo") as [Logo]
            logos = result
        } catch {
            throw NSError(domain: "Invalid Data", code: 303)
        }
        return logos
    }
}

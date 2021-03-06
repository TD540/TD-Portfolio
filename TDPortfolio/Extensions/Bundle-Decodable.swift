//
//  Bundle-Decodable.swift
//  TD Portfolio
//
//  Created by thomas on 13/12/2020.
//

// This file is done, no linting needed.
// swiftlint:disable line_length

import Foundation

extension Bundle {
    func decode<T: Decodable>(
        _ type: T.Type,
        from file: String,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) -> T {

        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Yeah no... Failed to locate \(file) from bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Yeah no... Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Yeah no... Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found = \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Yeah no... Failed to decode \(file) from bundle due to type mismatch - \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Yeah no... Failed to decode \(file) from bundle due to missing \(type) value = \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Yeah no... Failed to decode \(file) form bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Yeah no... Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}

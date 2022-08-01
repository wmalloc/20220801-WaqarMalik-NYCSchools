//
//  Dictionary+URLQueryItem.swift
//
//
//  Created by Waqar Malik on 7/30/22.
//

import Foundation

public extension Dictionary where Key == String, Value == String {
	var urlQueryItems: [URLQueryItem] {
		compactMap { (key: String, value: String) in
			guard let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
				return nil
			}
			return URLQueryItem(name: encodedKey, value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
		}
	}
}

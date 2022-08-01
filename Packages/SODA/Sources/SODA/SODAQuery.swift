//
//  SODAQuery.swift
//
//
//  Created by Waqar Malik on 7/30/22.
//

import Foundation

public struct SODAQuery: RawRepresentable {
	public typealias RawValue = [String: String]

	public var rawValue: [String: String]

	public init() {
		self.rawValue = [:]
	}

	public init?(rawValue: [String: String]) {
		self.rawValue = rawValue
	}

	public enum OrderBy: String, Hashable, CaseIterable {
		case ascending = "ASC"
		case decending = "DESC"
	}

	public var count: Int {
		rawValue.count
	}

	public subscript(key: String) -> String? {
		rawValue[key]
	}
}

public extension SODAQuery {
	func limit(_ limit: Int) -> Self {
		var query = self
		query.rawValue["$limit"] = "\(limit)"
		return query
	}

	func offset(_ offset: Int) -> Self {
		var query = self
		query.rawValue["$offset"] = "\(offset)"
		return query
	}

	func select(_ select: String) -> Self {
		var query = self
		query.rawValue["$select"] = select
		return query
	}

	func filter(_ filter: String) -> Self {
		var query = self
		query.rawValue["$where"] = filter
		return query
	}

	func filter(column: String, value: String) -> Self {
		var query = self
		query.rawValue[column] = value
		return query
	}

	func search(_ search: String) -> Self {
		var query = self
		query.rawValue["$q"] = search
		return query
	}

	// by == ASC or DESC
	func order(column: String, by: OrderBy) -> Self {
		var query = self
		query.rawValue["$order"] = "\(column) \(by.rawValue)"
		return query
	}

	func group(_ column: String) -> Self {
		var query = self
		query.rawValue["$group"] = column
		return query
	}
}

extension SODAQuery {
	var urlQueryItems: [URLQueryItem] {
		rawValue.urlQueryItems
	}
}

extension SODAQuery: CustomStringConvertible {
	public var description: String {
		rawValue.description
	}
}

extension SODAQuery: CustomDebugStringConvertible {
	public var debugDescription: String {
		rawValue.debugDescription
	}
}

extension SODAQuery.OrderBy: CustomStringConvertible {
	public var description: String {
		switch self {
		case .ascending:
			return "Ascending"
		case .decending:
			return "Decending"
		}
	}
}

extension SODAQuery.OrderBy: CustomDebugStringConvertible {
	public var debugDescription: String {
		rawValue
	}
}

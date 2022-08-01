//
//  SODAError.swift
//
//
//  Created by Waqar Malik on 7/30/22.
//

import Foundation

public let SODAErrorDomain = "com.socrata.opendata.Error"

private enum SODAServerErrorKey: String {
	case code
	case error
	case message
	case data
}

public enum SODAError: LocalizedError {
	case notFound(String)
	case serverError([String: Any])

	init?(dictionary: [String: Any]) {
		// Check if the content contains and error. The error field should be true, if it is missing or false then
		// we do not have an error
		guard let error = dictionary[SODAServerErrorKey.error.rawValue] as? Bool, error else {
			return nil
		}
		self = .serverError(dictionary)
	}
}

extension SODAError: CustomNSError {
	public static var errorDomain: String = SODAErrorDomain

	public var errorCode: Int {
		switch self {
		case .notFound:
			return 404
		case .serverError:
			return 500
		}
	}

	public var errorUserInfo: [String: Any] {
		switch self {
		case .notFound(let message):
			var userInfo: [String: Any] = [:]
			userInfo[NSLocalizedDescriptionKey] = message
			return userInfo
		case .serverError(let dictionary):
			var userInfo: [String: Any] = [:]
			let message = dictionary[SODAServerErrorKey.message.rawValue] as? String ?? NSLocalizedString("SODA_UNKOWN_ERROR", comment: "Unknown Error")
			userInfo[NSLocalizedDescriptionKey] = message
			userInfo[SODAServerErrorKey.data.rawValue] = dictionary
			return userInfo
		}
	}
}

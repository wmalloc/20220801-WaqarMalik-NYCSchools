//
//  SODAClient.swift
//
//
//  Created by Waqar Malik on 7/29/22.
//

import Foundation
import WebService
import WebServiceConcurrency

public protocol URLRequestConvertable {
	func url(resource: String, parameters: [String: String]) throws -> URL
	func request(method: HTTPMethod, url: URL) throws -> URLRequest
}

public class SODAClient {
	public enum Configuration {
		public static var defaultLimit: Int = 1000
	}

	let webService: WebService
	public let domain: String
	public let token: String?

	public init(domain: String, token: String?, session: URLSession = .shared) {
		self.domain = domain
		self.token = token
		self.webService = WebService(session: session)
	}

	public func GET<ResultType: Decodable>(resource: String, query: SODAQuery? = SODAQuery(rawValue: [:])?.limit(Configuration.defaultLimit).offset(0),
	                                       transform: @escaping WebService.DataMapper<Data, ResultType> = { result in try JSONDecoder().decode(ResultType.self, from: result) }) async throws -> ResultType
	{
		let url = try url(resource: resource, parameters: query?.rawValue ?? [:])
		let request = try request(method: .GET, url: url)
		let (data, response) = try await webService.data(for: request)
		_ = try response.ws_validate()
		let resultData = try data.ws_validateNotEmptyData()
		let resultObject = try JSONSerialization.jsonObject(with: resultData)
		if let row = resultObject as? [String: Any] {
			if let error = SODAError(dictionary: row) {
				throw error
			}
		}
		let decodedResult = try transform(resultData)
		return decodedResult
	}
}

extension SODAClient: URLRequestConvertable {
	public func url(resource: String, parameters: [String: String]) throws -> URL {
		let queryItems = parameters.urlQueryItems
		var components = URLComponents()
		components.scheme = "https"
		components.host = domain
		components.path = (resource.hasPrefix("/") ? resource : "/resource/" + resource) + ".json"
		components.queryItems = queryItems.isEmpty ? nil : queryItems
		guard let url = components.url else {
			throw URLError(.badURL)
		}
		return url
	}

	public func request(method: HTTPMethod, url: URL) throws -> URLRequest {
		if let token = token, token.isEmpty {
			throw URLError(.userAuthenticationRequired)
		}

		let urlRequest = URLRequest(url: url)
			.setMethod(method)
			.setHttpHeader(URLRequest.ContentType.json, forName: URLRequest.Header.accept)
			.setHttpHeader(token, forName: "X-App-Token")
		return urlRequest
	}
}

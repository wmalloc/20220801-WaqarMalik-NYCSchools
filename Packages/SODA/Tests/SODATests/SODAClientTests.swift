//
//  SODAClientTests.swift
//
//
//  Created by Waqar Malik on 7/30/22.
//

import os.log
@testable import SODA
import WebService
import WebServiceURLMock
import XCTest

final class SODAClientTests: XCTestCase {
	var domain = "data.cityofnewyork.us"
	var token = "abcdefg"
	var client: SODAClient?

	override func setUpWithError() throws {
		let config = URLSessionConfiguration.default
		config.protocolClasses = [URLProtocolMock.self]

		// and create the URLSession from that
		let session = URLSession(configuration: config)
		client = SODAClient(domain: domain, token: token, session: session)
	}

	override func tearDownWithError() throws {
		client = nil
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testClient() throws {
		XCTAssertEqual(client?.domain, domain)
		XCTAssertEqual(client?.token, token)
	}

	func testRequest() throws {
		let resource = NYCResources.schools.rawValue
		XCTAssertNotNil(client)
		let url = try client!.url(resource: resource, parameters: [:])
		XCTAssertEqual(url.absoluteString, "https://\(domain)/resource/\(resource).json")
		let request = try client!.request(method: .GET, url: url)
		XCTAssertEqual(request.httpMethod, "GET")
		XCTAssertEqual(request.value(forHTTPHeaderField: URLRequest.Header.accept), URLRequest.ContentType.json)
		XCTAssertEqual(request.value(forHTTPHeaderField: "X-App-Token"), token)
	}

	func testDataSchoolsResponse() async throws {
		let resource = "s3k6-pzi2"
		guard let url = Bundle.module.url(forResource: resource, withExtension: "json", subdirectory: "TestData") else {
			throw URLError(.fileDoesNotExist)
		}

		let data = try Data(contentsOf: url)
		URLProtocolMock.requestHandler = { request in
			guard let url = request.url, url.absoluteString.contains("/resource/\(resource).json") else {
				throw URLError(.badURL)
			}
			return (HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!, data)
		}

		let schools: [School]? = try await client?.GET(resource: resource)
		XCTAssertNotNil(schools)
		XCTAssertEqual(schools?.count, 440)
	}

	func testAuthInvalid() async throws {
		let resource = "s3k6-pzi2"
		let data = Data()
		URLProtocolMock.requestHandler = { request in
			guard let url = request.url, url.absoluteString.contains("/resource/\(resource).json") else {
				throw URLError(.badURL)
			}
			return (HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: nil)!, data)
		}

		do {
			let schools: [School]? = try await client?.GET(resource: resource)
			// we should not end up here
			XCTAssertNil(schools)
		} catch {
			let nsError = error as NSError
			XCTAssertEqual(nsError.code, 401)
		}
	}
}

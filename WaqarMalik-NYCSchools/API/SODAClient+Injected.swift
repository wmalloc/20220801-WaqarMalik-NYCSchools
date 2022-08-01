//
//  SODAClient+Injected.swift
//  WaqarMalik-NYCSchools
//
//  Created by Waqar Malik on 7/30/22.
//

import Foundation
import SODA

private struct SODAClientProviderKey: InjectionKey {
	private static let domain = "data.cityofnewyork.us"
	private static let token: String? = nil
	static var currentValue: SODAClient = .init(domain: domain, token: token)
}

extension InjectedValues {
	var sodaClient: SODAClient {
		get { Self[SODAClientProviderKey.self] }
		set { Self[SODAClientProviderKey.self] = newValue }
	}
}

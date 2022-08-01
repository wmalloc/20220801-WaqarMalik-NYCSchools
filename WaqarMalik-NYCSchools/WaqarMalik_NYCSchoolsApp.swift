//
//  WaqarMalik_NYCSchoolsApp.swift
//  WaqarMalik-NYCSchools
//
//  Created by Waqar Malik on 7/29/22.
//

import SwiftUI

@main
struct WaqarMalik_NYCSchoolsApp: App {
	var body: some Scene {
		WindowGroup {
			SchoolListView()
				.environmentObject(SchoolListViewModel())
		}
	}
}

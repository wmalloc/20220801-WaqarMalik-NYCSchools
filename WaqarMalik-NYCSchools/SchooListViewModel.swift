//
//  SchooListViewModel.swift
//  WaqarMalik-NYCSchools
//
//  Created by Waqar Malik on 7/30/22.
//

import Combine
import Foundation
import os.log
import SODA
import SwiftUI

class SchoolListViewModel: ObservableObject {
	@Injected(\.sodaClient) var sodaClient: SODAClient
	@Published var schools: [SchoolViewModel] = []
	@Published var isShowingHUD: Bool = false
	@Published var isShowingErrorAlert = false
	@Published var error: Error? = nil

    var haveData: Bool {
        !schools.isEmpty
    }
    
    func schools(matching value: String) -> [SchoolViewModel] {
        guard !value.isEmpty else {
            return schools
        }
        return schools.filter { viewModel in
            viewModel.name.contains(value)
        }
    }
    
	var title: LocalizedStringKey {
		"NYC_LISTVIEW_TITLE"
	}

    func reset() {
        fetchTask?.cancel()
        isShowingHUD = false
        isShowingErrorAlert = false
        error = nil
        schools.removeAll(keepingCapacity: true)
    }
    
    func refreshData() {
        reset()
        fetchSchools()
    }
    
    var fetchTask: Task<Void, Never>?
    func fetchSchools(offset: Int = 0, limit: Int = 1000) {
        fetchTask?.cancel()
        fetchTask = Task.detached { [weak self] in
			guard let self = self else {
				return
			}
			await MainActor.run { [weak self] in
				self?.isShowingHUD = true
			}
			do {
				let query = SODAQuery()
					.limit(limit)
					.offset(offset)
				let result = try await self.sodaClient.schools(query: query)
				await MainActor.run { [weak self] in
					self?.schools.append(contentsOf: result.map { school in
						SchoolViewModel(school: school)
					})
				}
			} catch {
				self.error = error
				os_log(.error, "Unable to fetch schools %@", error as NSError)
			}
			await MainActor.run { [weak self] in
				self?.isShowingHUD = false
			}
		}
	}
}

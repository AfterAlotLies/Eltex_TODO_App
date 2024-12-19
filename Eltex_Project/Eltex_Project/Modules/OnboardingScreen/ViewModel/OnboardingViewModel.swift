//
//  OnboardingViewModel.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 19.12.2024.
//

import Foundation
import Combine

final class OnboardingViewModel {
    
    @Published private(set) var pageData: [Page]?
    @Published private(set) var paginationScrollProgreess: CGFloat = 0
    @Published private(set) var paginationButtonHandlerProgress: CGFloat = 0
    
    let isFinished = PassthroughSubject<Void, Never>()
    
    init() {
        setPageData()
    }
    
    func didChangePaginationScrollProgress(for pageWidth: CGFloat, with contentOffsetX: CGFloat) {
        paginationScrollProgreess = contentOffsetX / pageWidth
    }
    
    func didChangePaginationButtonHandlerProgress(for pagesCount: Int, with progress: CGFloat) {
        let nextPage = Int(progress + 1)
        guard nextPage < pagesCount else { return }
        paginationButtonHandlerProgress = CGFloat(nextPage)
    }
    
    func didFinish() {
        isFinished.send()
    }
    
}

private extension OnboardingViewModel {
    
    func setPageData() {
        pageData = [
            Page(imageName: "firstImage", title: "Plan your tasks to do, that way you’ll stay organized and you won’t skip any"),
            Page(imageName: "secondImage", title: "Make a full schedule for the whole week and stay organized and productive all days"),
            Page(imageName: "thirdImage", title: "create a team task, invite people and manage your work together"),
            Page(imageName: "fourthImage", title: "You informations are secure with us")
        ]
    }
}

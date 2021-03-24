//
//  UserViewModel.swift
//  Login
//
//  Created by Dima on 1/22/21.
//  Copyright © 2021 Dima. All rights reserved.
//
import Combine
import Foundation
class UserViewModel: ObservableObject {
    private var cancellableSet: Set<AnyCancellable> = []
    @Published var emailname = ""
    @Published var isLimit: Bool = true
    @Published var isEmailValid: Bool = true
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var flag: Bool = false
    @Published var showHud: Bool = false
    let time = 3.0
    private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
        $username
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count >= 3
        }
        .eraseToAnyPublisher()
    }
    private var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count >= 3
        }
        .eraseToAnyPublisher()
    }
    private var isValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isPasswordValidPublisher, isUsernameValidPublisher)
            .map { nameIsValid, passwordIsValid in
                return nameIsValid && passwordIsValid
        }
        .eraseToAnyPublisher()
    }
    init() {
        isValid
            .receive(on: RunLoop.main)
            .assign(to: \.isLimit, on: self)
            .store(in: &cancellableSet)
    }
    
    func callDelay() {
        showHud = true
        let _delay = RunLoop.SchedulerTimeType(.init(timeIntervalSinceNow: self.time))
        RunLoop.main.schedule(after: _delay) {
            self.showHud = false
        }
        
        
    }
}



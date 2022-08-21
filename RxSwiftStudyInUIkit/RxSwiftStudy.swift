//
//  RxSwiftStudy.swift
//  RxSwiftStudy
//
//  Created by won soohyeon on 2022/08/21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class Study {
    
    deinit {
        print("deinit study")
    }
    private let disposeBag = DisposeBag()
    
    let input = Input()
    private let output = Output()
    
    struct Input {
        let observable = PublishRelay<String>()
    }
    
    struct Output {
        let router = PublishRelay<String>()
        
        let relay = PublishRelay<String>()
        let subject = PublishSubject<String>()
        
        let behaviorRelay = BehaviorRelay<String>(value: "init")
        let behaviorSubject = BehaviorSubject<String>(value: "init")
    }
    
    private func createSingleRequester() -> Single<String> {
        return Single<String>.create { single in
            print("createSingleRequester😤")
            single(.success("Single"))
            return Disposables.create()
        }
    }
    
    private func createObservableRequester() -> Observable<String> {
        return Observable<String>.create { observer in
            print("createObservableRequester😇")
            observer.onNext("Observable1")
            observer.onCompleted() // X
            return Disposables.create()
        }
    }
    
    func studyObservable() {
        let apiRequester = createObservableRequester()

        apiRequester
            .bind(to: output.relay)
            .disposed(by: disposeBag)
        
        apiRequester
            .bind(to: output.subject)
            .disposed(by: disposeBag)
        
        apiRequester
            .bind(to: output.behaviorRelay)
            .disposed(by: disposeBag)
        
        apiRequester
            .bind(to: output.behaviorSubject)
            .disposed(by: disposeBag)
    }
    
    func studyObservableShare() {
        let apiRequester = createObservableRequester().share(replay:1)

        apiRequester
            .bind(to: output.relay)
            .disposed(by: disposeBag)
        
        apiRequester
            .bind(to: output.subject)
            .disposed(by: disposeBag)
        
        apiRequester
            .bind(to: output.behaviorRelay)
            .disposed(by: disposeBag)
        
        apiRequester
            .bind(to: output.behaviorSubject)
            .disposed(by: disposeBag)
    }
    
    func studySingle() {
        let apiRequester = createSingleRequester().asObservable()

        apiRequester
            .bind(to: output.relay)
            .disposed(by: disposeBag)
        
        apiRequester
            .bind(to: output.subject)
            .disposed(by: disposeBag)
        
        apiRequester
            .bind(to: output.behaviorRelay)
            .disposed(by: disposeBag)
        
        apiRequester
            .bind(to: output.behaviorSubject)
            .disposed(by: disposeBag)
    }
    
    func studySingleShare() {
        let apiRequester = createSingleRequester().asObservable()

        apiRequester
            .bind(to: output.relay)
            .disposed(by: disposeBag)
        
        apiRequester
            .bind(to: output.subject)
            .disposed(by: disposeBag)
        
        apiRequester
            .bind(to: output.behaviorRelay)
            .disposed(by: disposeBag)
        
        apiRequester
            .bind(to: output.behaviorSubject)
            .disposed(by: disposeBag)
    }
    
    func routerRelay() {
        let apiRequester = createSingleRequester().asObservable()

        apiRequester
            .bind(to: output.router)
            .disposed(by: disposeBag)
    }
    
    func routerSubject() {
        let apiRequester = createSingleRequester().asObservable()

        apiRequester
            .bind(to: output.subject)
            .disposed(by: disposeBag)
    }
    
    func bindInput() {
        let observable = input.observable
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.createSingleRequester()
            }
            .asObservable()
            .share()
        
        observable
            .bind(to: output.relay)
            .disposed(by: disposeBag)
        
        observable
            .bind(to: output.subject)
            .disposed(by: disposeBag)
        
        observable
            .bind(to: output.behaviorRelay)
            .disposed(by: disposeBag)
        
        observable
            .bind(to: output.behaviorSubject)
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        output.relay
            .subscribe(onNext: { test in
                print("👹PublishRelay:\(test)")
            })
            .disposed(by: disposeBag)
        
        output.subject
            .subscribe(onNext: { test in
                print("👿PublishSubject:\(test)")
            })
            .disposed(by: disposeBag)
        
        output.behaviorRelay
            .subscribe(onNext: { test in
                print("👺behaviorRelay:\(test)")
            })
            .disposed(by: disposeBag)
        
        output.behaviorSubject
            .subscribe(onNext: { test in
                print("👾behaviorSubject:\(test)")
            })
            .disposed(by: disposeBag)
        
        output.router
            .subscribe(onNext: { test in
                print("🤝Router1 PublishRelay:\(test)")
            })
            .disposed(by: disposeBag)
        
        output.router
            .subscribe(onNext: { test in
                print("🤝Router2 PublishRelay:\(test)")
            })
            .disposed(by: disposeBag)
    }
}

/**
 결론
 
 1. input 변수를 통해서 API 를 request하고, 이를 share형태로 사용한다.
 - 장점: subject, behavior 모두 사용가능한 방식 이고 share()를 사용하여  API 가 중복호출 될 위험이 적다.
 - 단점: 함수로 호출될 때보다 디버깅이 힘들 수 있음, 테스트코드로 해결 할 수 있지만 우리 구조에서는 불가능하다.
 
 2. 여러번 호출되는 곳에서 Subject 선언을 지양한다. relay로 작성되어야함.
 - 장점: 기존 아키텍처로 작성된 곳을 수정할 필요없음
 - 단점: 구성원들 모두가 relay와 subject에 대한 이해도를 가져야함 무분별한 relay가 생성될 수 있음.
 
 + 참고의견
 2번 선택시 Observable<String>.create 시에 Share()를 사용하려면 onCompleted를 작성하지 않아야함
 Single 로 네트워크를 호출하면 Share()를 사용할 수 없기때문에 traits를 사용하는 장점을 잃는다.
 - 장점: 기존 코드에서 onCompleted 코드만 삭제해주면될듯하다. // deinit이 호출이 잘 되는것은 확인 완료
 - 단점: 항상 onCompleted를 작성하지 않는다고 가정하자면 의미가 모호해 질 수 있음
 
 3. Single, 하나의 Output만을 둔다. // Router 코드 참고
 Network request는 Single을 유지하되
 Requester를 구독하면 반드시! 하나의 output을 호출하게 만들고 해당 output을 구독하여 사용한다.
 Relay를사용해야함
 
 */

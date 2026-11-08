//
//  SPDidomiEventListener.swift
//  Pods
//
//  Created by Andre Herculano on 26/08/2026.
//

import Didomi
import Foundation

typealias DidomiEventListener = EventListener

class SPDidomiEventListener {
    var onConsentUIReady: (_ vc: UIViewController) -> Void = { _ in }
    var onConsentUIFinished: (_ vc: UIViewController) -> Void = { _ in }
    var onAction: (_ action: SPAction) -> Void = { _ in }
    var onError: (_ error: SPError) -> Void = { _ in }
    var onConsentChanged: () -> Void = { }

    public var didomiEventListener = DidomiEventListener()

    lazy var defaultEventListenerLambda: (_ event: DidomiEventType) -> Void = { [weak self] eventType in
        print("DidomiEventType \(eventType)")
        switch eventType {
        case .noticeClickAgree, .preferencesClickAgreeToAll:
            self?.onAction(SPAction(type: .AcceptAll))
        case .noticeClickDisagree, .preferencesClickDisagreeToAll:
            self?.onAction(SPAction(type: .RejectAll))
        case .preferencesClickSaveChoices:
            self?.onAction(SPAction(type: .SaveAndExit))
        default: return
        }
    }

    init() {
        didomiEventListener.onConsentUIReady = { [weak self] event in
            if let vc = event?.viewController {
                self?.onConsentUIReady(vc)
            }
        }
        didomiEventListener.onConsentUIFinished = { [weak self] event in
            if let vc = event?.viewController {
                self?.onConsentUIFinished(vc)
            }
        }
        didomiEventListener.onNoticeClickAgree = defaultEventListenerLambda
        didomiEventListener.onPreferencesClickAgreeToAll = defaultEventListenerLambda
        didomiEventListener.onNoticeClickDisagree = defaultEventListenerLambda
        didomiEventListener.onPreferencesClickDisagreeToAll = defaultEventListenerLambda
        didomiEventListener.onPreferencesClickSaveChoices = defaultEventListenerLambda
        didomiEventListener.onError = { [weak self] errorEvent in
            self?.onError(SPError(error: SPDidomiError(errorEvent)))
        }
        didomiEventListener.onConsentChangedWithObject = { [weak self] _ in
            self?.onConsentChanged()
        }
    }
}

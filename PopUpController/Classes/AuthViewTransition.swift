//
//  AuthViewTransition.swift
//  PopUpController
//


import UIKit

extension AuthView {
    
    func transitionFor(_ view: UIView, withAnimation animation: Bool = true) -> Bool {
        let flag = !view.isHidden
        
        let activeClosure: () -> Void = { [unowned self] in
            self.associatedViewConstraint[view]?.forEach { $0.isActive = !flag }
        }
        let hiddenClosure: () -> Void = {
            view.isHidden = flag
        }
        
        if flag {
            activeClosure()
        }
        
        if animation {
            UIView.animate(withDuration: AuthView.ANIMATION_DURATION, animations: {
                hiddenClosure()
            })
        } else {
            hiddenClosure()
        }
        
        if !flag {
            activeClosure()
        }
        
        return flag
    }
    
}

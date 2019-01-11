//
//  UIVIew+Constraints.swift
//  NexusCustomer
//
//  Created by Ivan Epifanov on 11/28/18.
//  Copyright © 2018 Intellectsoft. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    @discardableResult
    public func fillSuperView(_ edges: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        
        let topConstraint = addTopConstraint(toView: superview, constant: edges.top)
        let leadingConstraint = addLeadingConstraint(toView: superview, constant: edges.left)
        let bottomConstraint = addBottomConstraint(toView: superview, constant: -edges.bottom)
        let trailingConstraint = addTrailingConstraint(toView: superview, constant: -edges.right)
        
        let constraints = [topConstraint, leadingConstraint, bottomConstraint, trailingConstraint]
        return constraints
    }
    
    @discardableResult
    public func applyFrameAsConstraints() -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        
        let leadingConstraint = addLeadingConstraint(toView: superview, constant: frame.origin.x)
        let topConstraint = addTopConstraint(toView: superview, constant: frame.origin.y)
        let widthConstraint = addWidthConstraint(constant: frame.width)
        let heightConstraint = addHeightConstraint(constant: frame.height)
        
        let constraints = [topConstraint, leadingConstraint, widthConstraint, heightConstraint]
        return constraints
    }
    
    @discardableResult
    public func addLeadingConstraint(toView view: UIView? = nil,
                                     attribute: NSLayoutConstraint.Attribute = .leading,
                                     relation: NSLayoutConstraint.Relation = .equal,
                                     constant: CGFloat = 0.0,
                                     multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        let constraint = createConstraint(attribute: .leading,
                                          toView: view,
                                          attribute: attribute,
                                          relation: relation,
                                          constant: constant,
                                          multiplier: multiplier)
        addConstraintToSuperview(constraint)
        return constraint
    }
    
    @discardableResult
    public func addTrailingConstraint(toView view: UIView? = nil,
                                      attribute: NSLayoutConstraint.Attribute = .trailing,
                                      relation: NSLayoutConstraint.Relation = .equal,
                                      constant: CGFloat = 0.0,
                                      multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        let constraint = createConstraint(attribute: .trailing,
                                          toView: view,
                                          attribute: attribute,
                                          relation: relation,
                                          constant: constant,
                                          multiplier: multiplier)
        addConstraintToSuperview(constraint)
        return constraint
    }
    
    @discardableResult
    public func addLeftConstraint(toView view: UIView? = nil,
                                  attribute: NSLayoutConstraint.Attribute = .left,
                                  relation: NSLayoutConstraint.Relation = .equal,
                                  constant: CGFloat = 0.0,
                                  multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        let constraint = createConstraint(attribute: .left,
                                          toView: view,
                                          attribute: attribute,
                                          relation: relation,
                                          constant: constant,
                                          multiplier: multiplier)
        addConstraintToSuperview(constraint)
        return constraint
    }
    
    @discardableResult
    public func addRightConstraint(toView view: UIView? = nil,
                                   attribute: NSLayoutConstraint.Attribute = .right,
                                   relation: NSLayoutConstraint.Relation = .equal,
                                   constant: CGFloat = 0.0,
                                   multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        let constraint = createConstraint(attribute: .right,
                                          toView: view,
                                          attribute: attribute,
                                          relation: relation,
                                          constant: constant,
                                          multiplier: multiplier)
        addConstraintToSuperview(constraint)
        return constraint
    }
    
    @discardableResult
    public func addTopConstraint(toView view: UIView? = nil,
                                 attribute: NSLayoutConstraint.Attribute = .top,
                                 relation: NSLayoutConstraint.Relation = .equal,
                                 constant: CGFloat = 0.0,
                                 multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        let constraint = createConstraint(attribute: .top,
                                          toView: view,
                                          attribute: attribute,
                                          relation: relation,
                                          constant: constant,
                                          multiplier: multiplier)
        addConstraintToSuperview(constraint)
        return constraint
    }
    
    @discardableResult
    public func addBottomConstraint(toView view: UIView? = nil,
                                    attribute: NSLayoutConstraint.Attribute = .bottom,
                                    relation: NSLayoutConstraint.Relation = .equal,
                                    constant: CGFloat = 0.0,
                                    multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        let constraint = createConstraint(attribute: .bottom,
                                          toView: view,
                                          attribute: attribute,
                                          relation: relation,
                                          constant: constant,
                                          multiplier: multiplier)
        addConstraintToSuperview(constraint)
        return constraint
    }
    
    @discardableResult
    public func addCenterXConstraint(toView view: UIView? = nil,
                                     relation: NSLayoutConstraint.Relation = .equal,
                                     constant: CGFloat = 0.0,
                                     multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        let constraint = createConstraint(attribute: .centerX,
                                          toView: view,
                                          attribute: .centerX,
                                          relation: relation,
                                          constant: constant,
                                          multiplier: multiplier)
        addConstraintToSuperview(constraint)
        return constraint
    }
    
    @discardableResult
    public func addCenterYConstraint(toView view: UIView? = nil,
                                     relation: NSLayoutConstraint.Relation = .equal,
                                     constant: CGFloat = 0.0,
                                     multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        let constraint = createConstraint(attribute: .centerY,
                                          toView: view,
                                          attribute: .centerY,
                                          relation: relation,
                                          constant: constant,
                                          multiplier: multiplier)
        addConstraintToSuperview(constraint)
        return constraint
    }
    
    @discardableResult
    public func addWidthConstraint(toView view: UIView? = nil,
                                   relation: NSLayoutConstraint.Relation = .equal,
                                   constant: CGFloat = 0.0,
                                   multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        let constraint = createConstraint(attribute: .width,
                                          toView: view,
                                          attribute: .width,
                                          relation: relation,
                                          constant: constant,
                                          multiplier: multiplier)
        addConstraintToSuperview(constraint)
        return constraint
    }
    
    @discardableResult
    public func addHeightConstraint(toView view: UIView? = nil,
                                    relation: NSLayoutConstraint.Relation = .equal,
                                    constant: CGFloat = 0.0,
                                    multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        let constraint = createConstraint(attribute: .height,
                                          toView: view,
                                          attribute: .height,
                                          relation: relation,
                                          constant: constant,
                                          multiplier: multiplier)
        addConstraintToSuperview(constraint)
        return constraint
    }
    
    private func addConstraintToSuperview(_ constraint: NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraint(constraint)
    }
    
    private func createConstraint(attribute attr1: NSLayoutConstraint.Attribute,
                                  toView: UIView?,
                                  attribute attr2: NSLayoutConstraint.Attribute,
                                  relation: NSLayoutConstraint.Relation,
                                  constant: CGFloat,
                                  multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: attr1,
            relatedBy: relation,
            toItem: toView,
            attribute: attr2,
            multiplier: multiplier,
            constant: constant)
        return constraint
    }
}

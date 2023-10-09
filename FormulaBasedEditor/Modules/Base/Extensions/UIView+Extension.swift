//
//  UIView+Extension.swift
//  braille-workspace-pages
//
//  Created by Denis Mandych on 12.08.2023.
//

import UIKit
import SwiftUI

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { ctx in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }

    private struct Preview: UIViewRepresentable {
        let view: UIView
        
        func makeUIView(context: Context) -> UIView {
            return view
        }
        
        func updateUIView(_ uiView: UIView, context: Context) { }
    }

    func showPreview() -> some View {
        Preview(view: self)
    }
}

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views { addSubview(view) }
    }

    @discardableResult
    func addSubviews(
        _ views: UIView...
    ) -> Self {
        views.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        return self
    }

    @discardableResult
    func fitToSuperview(
        edges: UIRectEdge = .all,
        insets: UIEdgeInsets = .zero,
        priority: UILayoutPriority = .required
    ) -> Self {
        guard let superview = superview else {
            assertionFailure("View must be added to superview firstly")
            return self
        }

        translatesAutoresizingMaskIntoConstraints = false

        var constraints: [NSLayoutConstraint] = []
        if edges.contains(.top) {
            constraints.append(
                topAnchor.constraint(
                    equalTo: superview.topAnchor,
                    constant: insets.top
                ).withPriority(priority)
            )
        }
        if edges.contains(.bottom) {
            constraints.append(
                bottomAnchor.constraint(
                    equalTo: superview.bottomAnchor,
                    constant: -insets.bottom
                ).withPriority(priority)
            )
        }
        if edges.contains(.left) {
            constraints.append(
                leftAnchor.constraint(
                    equalTo: superview.leftAnchor,
                    constant: insets.left
                ).withPriority(priority)
            )
        }
        if edges.contains(.right) {
            constraints.append(
                rightAnchor.constraint(
                    equalTo: superview.rightAnchor,
                    constant: -insets.right
                ).withPriority(priority)
            )
        }

        NSLayoutConstraint.activate(constraints)
        return self
    }

    @discardableResult
    func exactSize(_ size: CGSize) -> Self {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ])
        return self
    }

    @discardableResult
    func aspectRatio(_ multiplier: CGFloat = 1) -> Self {
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: multiplier).isActive = true
        return self
    }

    @discardableResult
    func centerVertically(offset: CGFloat = 0) -> Self {
        withSuperview {
            prepareForLayout()
            centerYAnchor
                .constraint(equalTo: $0.centerYAnchor, constant: offset)
                .isActive = true
        }
    }

    @discardableResult
    func centerVertically(to: NSLayoutYAxisAnchor, offset: CGFloat = 0) -> Self {
        centerYAnchor.constraint(equalTo: to, constant: offset).isActive = true
        return self
    }

    @discardableResult
    func centerVertically(to view: UIView, constant: CGFloat = 0) -> Self {
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        return self
    }

    @discardableResult
    func centerHorizontally() -> Self {
        withSuperview {
            prepareForLayout()
            centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
        }
    }

    @discardableResult
    func trailingSpace(_ constant: CGFloat = 0, to view: UIView) -> Self {
        prepareForLayout()
        trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).isActive = true
        return self
    }

    @discardableResult
    func trailing(
        _ constant: CGFloat = 0,
        to view: UIView? = nil,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> Self {
        withSuperview {
            prepareForLayout()
            let toAnchor = (view ?? $0).trailingAnchor
            trailingAnchor
                .constraint(to: toAnchor, constant: -constant, relation: relation)
                .isActive = true
        }
    }

    @discardableResult
    func leading(
        _ constant: CGFloat = 0,
        to view: UIView? = nil,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required
    ) -> Self {
        withSuperview {
            prepareForLayout()
            let toAnchor = (view ?? $0).leadingAnchor
            leadingAnchor
                .constraint(to: toAnchor, constant: constant, relation: relation)
                .with(priority: priority)
                .isActive = true
        }
    }

    @discardableResult
    func leading(
        _ constant: CGFloat = 0,
        to constraint: NSLayoutXAxisAnchor,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required
    ) -> Self {
        withSuperview {_ in
            prepareForLayout()
            leadingAnchor
                .constraint(to: constraint, constant: constant, relation: relation)
                .with(priority: priority)
                .isActive = true
        }
    }

    @discardableResult
    func leadingAndTrailing(_ constant: CGFloat = 0) -> Self {
        withSuperview {
            prepareForLayout()
            leadingAnchor.constraint(equalTo: $0.leadingAnchor, constant: constant).isActive = true
            trailingAnchor.constraint(equalTo: $0.trailingAnchor, constant: -constant).isActive = true
        }
    }

    @discardableResult
    func leadingAndTrailingGreaterOrEqual(_ constant: CGFloat = 0) -> Self {
        withSuperview {
            prepareForLayout()
            leadingAnchor.constraint(greaterThanOrEqualTo: $0.leadingAnchor, constant: constant).isActive = true
            trailingAnchor.constraint(lessThanOrEqualTo: $0.trailingAnchor, constant: -constant).isActive = true
        }
    }

    @discardableResult
    func top(
        _ constant: CGFloat = 0,
        to view: UIView? = nil,
        anchor: NSLayoutYAxisAnchor? = nil,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required
    ) -> Self {
        withSuperview {
            prepareForLayout()
            if let view = view {
                topAnchor
                    .constraint(to: anchor ?? view.bottomAnchor, constant: constant, relation: relation)
                    .with(priority: priority)
                    .isActive = true
            } else {
                topAnchor
                    .constraint(equalTo: anchor ?? $0.topAnchor, constant: constant)
                    .with(priority: priority)
                    .isActive = true
            }
        }
    }

    @discardableResult
    func firstBaseline(_ constant: CGFloat = 0, to view: UIView) -> Self {
        prepareForLayout()
        firstBaselineAnchor.constraint(equalTo: view.firstBaselineAnchor).isActive = true
        return self
    }

    @discardableResult
    func safeAreaLeading(_ constant: CGFloat = 0) -> Self {
        withSuperview {
            prepareForLayout()
            leadingAnchor.constraint(equalTo: $0.safeAreaLayoutGuide.leadingAnchor, constant: constant).isActive = true
        }
    }

    @discardableResult
    func safeAreaTrailing(_ constant: CGFloat = 0) -> Self {
        withSuperview {
            prepareForLayout()
            trailingAnchor.constraint(
                equalTo: $0.safeAreaLayoutGuide.trailingAnchor,
                constant: constant
            ).isActive = true
        }
    }

    @discardableResult
    func safeAreaTop(_ constant: CGFloat = 0) -> Self {
        withSuperview {
            prepareForLayout()
            topAnchor.constraint(equalTo: $0.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
        }
    }

    @discardableResult
    func safeAreaBottom(_ constant: CGFloat = 0) -> Self {
        withSuperview {
            prepareForLayout()
            bottomAnchor.constraint(equalTo: $0.safeAreaLayoutGuide.bottomAnchor, constant: constant).isActive = true
        }
    }

    @discardableResult
    func left(
        _ constant: CGFloat = 0,
        to view: UIView? = nil,
        anchor: NSLayoutXAxisAnchor? = nil,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required
    ) -> Self {
        withSuperview {
            prepareForLayout()
            let toAnchor = anchor ?? view.map { $0.rightAnchor } ?? $0.leftAnchor
            leftAnchor
                .constraint(to: toAnchor, constant: constant, relation: relation)
                .withPriority(priority)
                .isActive = true
        }
    }

    @discardableResult
    func right(
        _ constant: CGFloat = 0,
        to view: UIView? = nil,
        anchor: NSLayoutXAxisAnchor? = nil,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required
    ) -> Self {
        withSuperview {
            prepareForLayout()
            let toAnchor = anchor ?? view.map { $0.leftAnchor } ?? $0.rightAnchor
            rightAnchor
                .constraint(to: toAnchor, constant: -constant, relation: relation)
                .withPriority(priority)
                .isActive = true
        }
    }

    @discardableResult
    func leftToRight(
        of view: UIView,
        _ constant: CGFloat = 0,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required
    ) -> Self {
        left(constant, to: view, anchor: view.rightAnchor, relation: relation, priority: priority)
    }

    @discardableResult
    func rightToLeft(
        of view: UIView,
        _ constant: CGFloat = 0,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required
    ) -> Self {
        right(
            constant,
            to: view,
            anchor: view.leftAnchor,
            relation: relation,
            priority: priority
        )
    }

    @discardableResult
    func rightLessThanOrEqualTo(_ constant: CGFloat = 0, to view: UIView? = nil) -> Self {
        withSuperview {
            prepareForLayout()
            if let view = view {
                rightAnchor.constraint(lessThanOrEqualTo: view.leftAnchor, constant: constant).isActive = true
            } else {
                rightAnchor.constraint(lessThanOrEqualTo: $0.rightAnchor, constant: constant).isActive = true
            }
        }
    }

    @discardableResult
    func bottom(
        _ constant: CGFloat = 0,
        to view: UIView? = nil,
        anchor: NSLayoutYAxisAnchor? = nil,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required
    ) -> Self {
        withSuperview {
            prepareForLayout()
            let toAnchor = anchor ?? view.map { $0.topAnchor } ?? $0.bottomAnchor
            bottomAnchor
                .constraint(to: toAnchor, constant: -constant, relation: relation)
                .with(priority: priority)
                .isActive = true
        }
    }

    @discardableResult
    func bottomToTop(
        of view: UIView,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> Self {
        bottom(constant, to: view, anchor: view.topAnchor, priority: priority)
    }
    
    @discardableResult
    func bottomToHorizontalCenter(
        of view: UIView,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> Self {
        bottom(constant, to: view, anchor: view.centerYAnchor, priority: priority)
    }

    @discardableResult
    func topToBottom(
        of view: UIView,
        _ constant: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> Self {
        top(constant, to: view, anchor: view.bottomAnchor, priority: priority)
    }

    @discardableResult
    func equalWidth(_ multiplier: CGFloat = 1, with view: UIView) -> Self {
        prepareForLayout()
        widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier).isActive = true
        return self
    }

    @discardableResult
    func equalHeight(_ multiplier: CGFloat = 1, with view: UIView) -> Self {
        prepareForLayout()
        heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier).isActive = true
        return self
    }

    @discardableResult
    func fixedWidth(
        _ constant: CGFloat = 0,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required
    ) -> Self {
        prepareForLayout()
        widthAnchor
            .constraint(constant: constant, relation: relation)
            .with(priority: priority)
            .isActive = true
        return self
    }

    @discardableResult
    func width(
        to view: UIView,
        constant: CGFloat = 0,
        dimension: NSLayoutDimension? = nil,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required
    ) -> Self {
        prepareForLayout()
        widthAnchor
            .constraint(to: dimension ?? view.widthAnchor, constant: constant, relation: relation)
            .with(priority: priority)
            .isActive = true
        return self
    }

    @discardableResult
    func widthToHeight(
        of view: UIView,
        constant: CGFloat = 0,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required
    ) -> Self {
        width(to: view, constant: constant, dimension: view.heightAnchor, relation: relation, priority: priority)
    }

    @discardableResult
    func fixedHeight(
        _ constant: CGFloat = 0,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required
    ) -> Self {
        prepareForLayout()
        heightAnchor
            .constraint(constant: constant, relation: relation)
            .with(priority: priority)
            .isActive = true
        return self
    }

    @discardableResult
    func height(
        to view: UIView,
        constant: CGFloat = 0,
        dimension: NSLayoutDimension? = nil,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required
    ) -> Self {
        prepareForLayout()
        heightAnchor
            .constraint(to: dimension ?? view.heightAnchor, constant: constant, relation: relation)
            .with(priority: priority)
            .isActive = true
        return self
    }

    @discardableResult
    func heightToWidth(
        of view: UIView,
        constant: CGFloat = 0,
        relation: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required
    ) -> Self {
        height(to: view, constant: constant, dimension: view.widthAnchor, relation: relation, priority: priority)
    }

    // MARK: - Private

    private func withSuperview(block: (UIView) -> Void) -> Self {
        guard let superview = superview else {
            assertionFailure("View must be added to superview firstly")
            return self
        }

        block(superview)
        return self
    }

}

private extension UIView {
    @discardableResult
    func prepareForLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}

private extension NSLayoutDimension {
    @objc func constraint(
        constant c: CGFloat,
        relation: NSLayoutConstraint.Relation
    ) -> NSLayoutConstraint {
        switch relation {
        case .equal:
            return constraint(equalToConstant: c)
        case .greaterThanOrEqual:
            return constraint(greaterThanOrEqualToConstant: c)
        case .lessThanOrEqual:
            return constraint(lessThanOrEqualToConstant: c)
        @unknown default:
            return constraint(equalToConstant: c)
        }
    }
}

private extension NSLayoutAnchor {
    @objc func constraint(
        to anchor: NSLayoutAnchor<AnchorType>,
        relation: NSLayoutConstraint.Relation
    ) -> NSLayoutConstraint {
        switch relation {
        case .equal:
            return constraint(equalTo: anchor)
        case .greaterThanOrEqual:
            return constraint(greaterThanOrEqualTo: anchor)
        case .lessThanOrEqual:
            return constraint(lessThanOrEqualTo: anchor)
        @unknown default:
            return constraint(equalTo: anchor)
        }
    }

    @objc func constraint(
        to anchor: NSLayoutAnchor<AnchorType>,
        constant c: CGFloat,
        relation: NSLayoutConstraint.Relation
    ) -> NSLayoutConstraint {
        switch relation {
        case .equal:
            return constraint(equalTo: anchor, constant: c)
        case .greaterThanOrEqual:
            return constraint(greaterThanOrEqualTo: anchor, constant: c)
        case .lessThanOrEqual:
            return constraint(lessThanOrEqualTo: anchor, constant: c)
        @unknown default:
            return constraint(equalTo: anchor, constant: c)
        }
    }
}

public extension NSLayoutConstraint {
    func with(priority: UILayoutPriority) -> Self {
        self.priority = priority
        return self
    }
}

public extension NSLayoutConstraint {
    @discardableResult
    func activate() -> NSLayoutConstraint {
        isActive = true
        return self
    }

    @discardableResult
    func deactivate() -> NSLayoutConstraint {
        isActive = false
        return self
    }

    @discardableResult
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

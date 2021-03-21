import UIKit

struct AnchoredConstraints {
    public var top, leading, bottom, trailing, vertical, horizontal, width, height: NSLayoutConstraint?
    
    func activate() {
        [top, leading, bottom, trailing, vertical, horizontal, width, height].forEach({ $0?.isActive = true })
    }
}

extension UIView {

    @discardableResult
    func stickToSuperviewEdges(_ edges: UIRectEdge, insets: UIEdgeInsets = .zero) -> AnchoredConstraints? {
        guard let superview = superview else {
            assertionFailure("View must be added to superview firstly")
            return nil
        }
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = AnchoredConstraints()

        if edges.contains(.top) {
            constraints.top = topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top)
        }
        if edges.contains(.bottom) {
            constraints.bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        }
        if edges.contains(.left) {
            constraints.leading = leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left)
        }
        if edges.contains(.right) {
            constraints.trailing = trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right)
        }
        constraints.activate()

        return constraints
    }

    @discardableResult
    func stickToSuperviewSafeEdges(_ edges: UIRectEdge, insets: UIEdgeInsets = .zero) -> AnchoredConstraints? {
        guard let superview = superview else {
            assertionFailure("View must be added to superview firstly")
            return nil
        }
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = AnchoredConstraints()

        if edges.contains(.top) {
            constraints.top = topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: insets.top)
        }
        if edges.contains(.bottom) {
            constraints.bottom = bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom)
        }
        if edges.contains(.left) {
            constraints.leading = leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: insets.left)
        }
        if edges.contains(.right) {
            constraints.trailing = trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -insets.right)
        }
        constraints.activate()

        return constraints
    }

}

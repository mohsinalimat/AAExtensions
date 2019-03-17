//
//  Extension+UIView.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

// MARK:- UIView
public extension UIView {

    func aa_fadeIn(withDuration duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }

    func aa_fadeOut(withDuration duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }

    func aa_addDashedLine(strokeColor: UIColor, lineWidth: CGFloat = 1) {

        backgroundColor = .clear

        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "DashedTopLine"
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: frame.width / 2, y: frame.height * 1.5)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6, 4]

        let path = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        shapeLayer.path = path

        layer.addSublayer(shapeLayer)
    }

    func aa_circular(borderWidth: CGFloat = 0, borderColor: UIColor) {
        let radius = self.bounds.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }

    func aa_roundedCorner(borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.white) {
        let radius = self.bounds.width / 2
        self.layer.cornerRadius = radius / 5
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }

    func aa_startGlowing(color: UIColor, radius: CGFloat = 1) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = radius

        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.shadowOpacity))
        animation.duration = 1
        animation.fromValue = layer.shadowOpacity
        animation.toValue = 0
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = .greatestFiniteMagnitude
        self.layer.add(animation, forKey: "animateOpacity")

    }

    func aa_isVisible(_ isVisible: Bool) {
        self.isHidden = !isVisible
        self.translatesAutoresizingMaskIntoConstraints = isVisible
        if isVisible { //if visible we remove the hight constraint
            if let constraint = (self.constraints.filter{$0.firstAttribute == .height}.first){
                self.removeConstraint(constraint)
            }
        } else { //if not visible we add a constraint to force the view to have a hight set to 0
            let height = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal , toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 0)
            self.addConstraint(height)
        }
        self.layoutIfNeeded()
    }


    func aa_endEditingOnTouch() {
        let tapper = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapper.cancelsTouchesInView = true
        addGestureRecognizer(tapper)
    }

    @objc private func hideKeyboard() {
        self.superview?.endEditing(true)
    }

    @available(iOS 9.0, *)
    func aa_addConstrainedSubview(_ subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func aa_addAndFitSubview(_ subview: UIView, insets: UIEdgeInsets = .zero) {
        addSubview(subview)
        subview.aa_fitInSuperview(with: insets)
    }

    func aa_fitInSuperview(with insets: UIEdgeInsets = .zero) {
        guard let superview = superview else {
            assertionFailure("AAExtension: fitInSuperview was called but view was not in a view hierarchy.")
            return
        }

        let applyInset: (NSLayoutConstraint.Attribute, UIEdgeInsets) -> CGFloat = {
            switch $0 {
            case .top: return $1.top
            case .bottom: return -$1.bottom
            case .left: return $1.left
            case .right: return -$1.right
            default:
                return 0
            }
        }

        translatesAutoresizingMaskIntoConstraints = false

        let attributes = [NSLayoutConstraint.Attribute.top, .left, .right, .bottom]
        superview.addConstraints(attributes.map {
            return NSLayoutConstraint(item: self,
                                      attribute: $0,
                                      relatedBy: .equal,
                                      toItem: superview,
                                      attribute: $0,
                                      multiplier: 1,
                                      constant: applyInset($0, insets))
        })
    }

    func aa_removeSubViews() {
        guard self.subviews.count > 0 else {
            return
        }
        self.subviews.forEach {$0.removeFromSuperview()}
    }

    func aa_insertLine( start: CGPoint, end: CGPoint, color: UIColor) -> CAShapeLayer {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = color.cgColor
        line.lineWidth = 0.3
        line.lineJoin = CAShapeLayerLineJoin.round
        self.layer.insertSublayer(line, at: 0)
        return line
    }

    func aa_addTopBorderWithColor(color: UIColor, width: CGFloat, paddingX: CGFloat, paddingY: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: paddingX, y: paddingY, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func aa_addRightBorderWithColor(color: UIColor, width: CGFloat, paddingX: CGFloat, paddingY: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: (self.frame.size.width - width) + paddingX, y: paddingY, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func aa_addBottomBorderWithColor(color: UIColor, width: CGFloat, paddingX: CGFloat, paddingY: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: paddingX, y: (self.frame.size.height - width) + paddingY, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func aa_addLeftBorderWithColor(color: UIColor, width: CGFloat, paddingX: CGFloat, paddingY: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: paddingX, y: paddingY, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }

    var aa_clonedView: Any? {
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archivedData)
    }

    func aa_insertDottedLine(start: CGPoint, end: CGPoint, color: UIColor) {
        let lineDashPattern: [NSNumber]?  = [3, 3]

        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 0.3
        shapeLayer.lineDashPattern = lineDashPattern

        let path = CGMutablePath()
        path.addLines(between: [start, end])

        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }

    func aa_constraint(view1: UIView, view2: UIView, attr1: NSLayoutConstraint.Attribute, attr2: NSLayoutConstraint.Attribute, constant: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: .equal, toItem: view2, attribute: attr2, multiplier: 1, constant: constant))
    }

    func aa_oneToOtherConstraint( view1: UIView, view2: UIView, attr1: NSLayoutConstraint.Attribute, attr2: NSLayoutConstraint.Attribute) {
        self.addConstraint(NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: .equal, toItem: view2, attribute: attr2, multiplier: 1, constant: 0))
    }

    func aa_constantConstaint(attr: NSLayoutConstraint.Attribute, constant: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: attr, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constant))
    }

    func aa_bindConstraints(_ view1: UIView, view2: UIView, bindAttrs: [NSLayoutConstraint.Attribute]) {
        let bindConstraints = bindAttrs.compactMap({ (attr) -> NSLayoutConstraint in
            return NSLayoutConstraint(item: view1, attribute: attr, relatedBy: .equal, toItem: view2, attribute: attr, multiplier: 1.0, constant: 0)
        })

        self.addConstraints(bindConstraints)
    }

    func aa_bindConstraints(_ withView: UIView, bindAttrs: [NSLayoutConstraint.Attribute]) {
        let bindConstraints = bindAttrs.compactMap({ (attr) -> NSLayoutConstraint in
            return NSLayoutConstraint(item: withView, attribute: attr, relatedBy: .equal, toItem: self, attribute: attr, multiplier: 1.0, constant: 0)
        })

        self.addConstraints(bindConstraints)
    }

    func aa_layoutItems(bindAttrs: [NSLayoutConstraint.Attribute], preAttr: NSLayoutConstraint.Attribute, nextAttr: NSLayoutConstraint.Attribute, equalAttr: NSLayoutConstraint.Attribute) {
        let items = self.subviews
        let constraints = items.enumerated().flatMap { (index, label) -> [NSLayoutConstraint] in
            var constraints: [NSLayoutConstraint] = [NSLayoutConstraint]()

            /// Constraints to bind the views
            let bindConstraints = bindAttrs.compactMap({ (attr) -> NSLayoutConstraint in
                return NSLayoutConstraint(item: label, attribute: attr, relatedBy: .equal, toItem: self, attribute: attr, multiplier: 1.0, constant: 0)
            })

            constraints.append(contentsOf: bindConstraints)

            /// Constraint after the view
            var nextConstraint : NSLayoutConstraint {

                guard index != items.count - 1 else {
                    return NSLayoutConstraint(item: label, attribute: nextAttr, relatedBy: .equal, toItem: self, attribute: nextAttr, multiplier: 1.0, constant: 0)
                }
                let nextItem = items[index+1]
                return NSLayoutConstraint(item: label, attribute: nextAttr, relatedBy: .equal, toItem: nextItem, attribute: preAttr, multiplier: 1.0, constant: 0)
            }

            constraints.append(nextConstraint)

            /// Constraint before the view
            var preConstraint : NSLayoutConstraint {

                guard index != 0 else {

                    return NSLayoutConstraint(item: label, attribute: preAttr, relatedBy: .equal, toItem: self, attribute: preAttr, multiplier: 1.0, constant: 0)
                }

                /// Constraint equal the first view
                let equalConstraint = NSLayoutConstraint(item: label, attribute: equalAttr, relatedBy: .equal, toItem: items.first!, attribute: equalAttr, multiplier: 1.0, constant: 0)

                constraints.append(equalConstraint)

                let prevItem = items[index-1]
                return NSLayoutConstraint(item: label, attribute: preAttr, relatedBy: .equal, toItem: prevItem, attribute: nextAttr, multiplier: 1.0, constant: 0)

            }

            constraints.append(preConstraint)

            return constraints
        }

        self.addConstraints(constraints)
    }

    func aa_addDashedBorder(strokeColor: UIColor, lineWidth: CGFloat) {
        self.layoutIfNeeded()
        let strokeColor = strokeColor.cgColor

        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round

        shapeLayer.lineDashPattern = [5,5] // adjust to your liking
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shapeRect.width, height: shapeRect.height), cornerRadius: self.layer.cornerRadius).cgPath

        self.layer.addSublayer(shapeLayer)
    }

    func aa_addTapGesture(_ target: Any, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    public func aa_dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    public func aa_dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

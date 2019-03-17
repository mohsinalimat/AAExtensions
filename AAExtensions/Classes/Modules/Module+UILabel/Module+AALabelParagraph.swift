//
//  Module+AALabelParagraph.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//


@available(iOS 9.0, *)
@IBDesignable
public class AALabelParagraph: UILabel {
    
    @IBInspectable open var isHorizontal: Bool = true
    @IBInspectable open var firstColor: UIColor = .black
    @IBInspectable open var secondOther: UIColor = .black
    @IBInspectable open var tabsSize: Int = 1
    
    func setAttrText(first: [String], second: [String]) {
        
        guard first.count == second.count else { return }
        
        var tabs = ""
        for _ in 0...tabsSize {
            tabs += "\t"
        }
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        for tabStop in paragraph.tabStops {
            paragraph.removeTabStop(tabStop)
        }
        if (!isHorizontal) {
            paragraph.addTabStop(NSTextTab(textAlignment: .right, location: 150.0, options: [:] ))
        }
        
        let text = NSMutableAttributedString()
        let leftAttributes = [
            NSAttributedString.Key.foregroundColor: firstColor,
            NSAttributedString.Key.paragraphStyle: paragraph
        ]
        let rightAttributes = [
            NSAttributedString.Key.foregroundColor: secondOther,
            NSAttributedString.Key.paragraphStyle: paragraph
        ]
        
        first.enumerated().forEach { (index, elem) in
            
            text.append(NSAttributedString(string: elem, attributes: leftAttributes))
            text.append(NSAttributedString(string: "\t\(second[index])\t\(tabs)", attributes: rightAttributes))
            if !isHorizontal, index != first.count - 1 {
                text.append(NSAttributedString(string: "\n"))
            }
        }
        
        self.attributedText = text
        
    }
    
    
}

import UIKit

@IBDesignable
class BorderedView: UIView {
    
    // MARK: - Stored Properties
    
    @IBInspectable var borderRadius: CGFloat = 0 {
        didSet { self.layer.cornerRadius = borderRadius }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet { self.layer.borderWidth = borderWidth }
    }
    @IBInspectable var borderColor: UIColor = .clear {
        didSet { self.layer.borderColor = borderColor.cgColor }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayer()
    }
    
    override func prepareForInterfaceBuilder() {
        setupLayer()
    }
    
    // MARK: - Setup
    
    private func setupLayer() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = borderRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}

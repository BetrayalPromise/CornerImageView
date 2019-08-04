import UIKit

public class CornerImageView: UIImageView {
    private struct Associated {
        static var kObserverImage: String = "kObserverImage"
    }
    /// 圆角半径
    private var cornerRadius: CGFloat = 0
    /// 圆角位置
    private var cornerPosition: UIRectCorner? = nil
    /// 边框宽度
    private var borderWidth: CGFloat = 0
    /// 边框颜色
    private var borderColor: UIColor? = UIColor.clear
    private var isHadAddObserver: Bool = false
    private var isRounding: Bool = false
    
    private func cornerRadius(with image: UIImage, cornerRadius: CGFloat, rectCornerType: UIRectCorner) {
        let size: CGSize = self.bounds.size
        let scale: CGFloat = UIScreen.main.scale
        let cornerRadii = CGSize(width: cornerRadius, height: cornerRadius)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let currentContext: CGContext = UIGraphicsGetCurrentContext() else { return }
        
        let cornerPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: rectCornerType, cornerRadii: cornerRadii)
        cornerPath.addClip()
        layer.render(in: currentContext)
        self.drawBorder(cornerPath)
        guard let processedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        objc_setAssociatedObject(processedImage, &Associated.kObserverImage, 1, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.image = processedImage
    }
    
    private func drawBorder(_ path: UIBezierPath) {
        if borderWidth != 0 {
            path.lineWidth = 2 * borderWidth
            borderColor?.setStroke()
            path.stroke()
        }
    }
    
    private func cornerRadiusAdvance(_ cornerRadius: CGFloat, rectCornerType: UIRectCorner) {
        self.cornerRadius = cornerRadius
        self.cornerPosition = rectCornerType
        self.isRounding = false
        if !self.isHadAddObserver {
            self.addObserver(self, forKeyPath: "image", options: .new, context: nil)
            self.isHadAddObserver = true
        }
        layoutIfNeeded()
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "image") {
            guard let newImage: UIImage = change?[.newKey] as? UIImage else { return }
            if type(of: newImage) === NSNull.self {
                return
            } else if (objc_getAssociatedObject(newImage, &Associated.kObserverImage) as? Int) == 1 {
                return
            }
            
            if isRounding {
                self.cornerRadius(with: newImage, cornerRadius: frame.size.width / 2, rectCornerType: .allCorners)
            } else if self.cornerRadius != 0 && self.cornerPosition != nil {
                self.cornerRadius(with: newImage, cornerRadius: self.cornerRadius, rectCornerType: self.cornerPosition!)
            }
        }
    }
    
    public convenience init(frame: CGRect, cornerRadius: CGFloat, cornerPositon: UIRectCorner?, borderColor: UIColor?, borderWidth: CGFloat) {
        self.init(frame: frame)
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.cornerRadius = cornerRadius
        self.cornerPosition = cornerPositon
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        guard let contentImage: UIImage = self.image else { return }
        self.cornerRadius(with: contentImage, cornerRadius: self.cornerRadius, rectCornerType: self.cornerPosition!)
    }
    
    deinit {
        if self.isHadAddObserver {
            self.removeObserver(self, forKeyPath: "image")
        }
    }

}

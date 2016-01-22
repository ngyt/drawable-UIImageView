import UIKit

class DrawableImageView: UIImageView {

    private var previousPoint: CGPoint?
    var strokeColor: UIColor = UIColor.blackColor()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        userInteractionEnabled = true
        
        let panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("panAction:"))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.maximumNumberOfTouches = 1
        addGestureRecognizer(panGestureRecognizer)
    }
    
    func panAction(sender: UIPanGestureRecognizer) {
        let point: CGPoint = sender.locationInView(self)
        
        image = drawImage(point)
        previousPoint = point
        
        if sender.state == .Ended {
            previousPoint = nil
        }
    }
    
    private func drawImage(point: CGPoint) -> UIImage? {
        let imageSize = frame.size
        var resultImage: UIImage?
        UIGraphicsBeginImageContext(imageSize)
        
        // copy current image
        image?.drawInRect(CGRectMake(0, 0, imageSize.width, imageSize.height))
        
        // add new line
        if let context: CGContextRef = UIGraphicsGetCurrentContext() {
            if let prePoint = previousPoint{
                CGContextSetStrokeColorWithColor(context, strokeColor.CGColor)
                CGContextSetLineCap(context, CGLineCap.Round)
                CGContextSetLineWidth(context, 10.0)
                CGContextMoveToPoint(context, prePoint.x, prePoint.y)
                CGContextAddLineToPoint(context, point.x, point.y)
                CGContextStrokePath(context)
            }
            
            CGContextFillPath(context)
            resultImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        UIGraphicsEndImageContext()
        
        return resultImage ?? image
    }
    
    func cleanImage() {
        self.image = nil
    }
}

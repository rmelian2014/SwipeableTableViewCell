 //
 //  SwipeableViewCell.swift
 //  czyPojade
 //
 //  Created by Błażej Wdowikowski on 26/05/2016.
 //  Copyright © 2016 dudi. All rights reserved.
 //
 
 import UIKit
 
 class SwipeableTableViewCell: UITableViewCell,UIScrollViewDelegate {
    enum SwipeableTableViewCellSide:Int {
        case Left
        case Right
    }
    
    private var buttonViews:[UIView]!
    private static let CloseEvent:String = "SwipeableTableViewCellClose"
    private let OpenVelocityThreshold:CGFloat = 0.6;
    private let MaxCloseMilliseconds:CGFloat = 300
    
    var scrollViewContentView:UIView = UIView()
    var scrollView:UIScrollView!
    var leftInset:CGFloat {
        let view = self.buttonViews[SwipeableTableViewCellSide.Left.rawValue]
        return view.bounds.width
    }
    var rightInset:CGFloat {
        let view = self.buttonViews[SwipeableTableViewCellSide.Right.rawValue]
        return view.bounds.width
    }
    
    var rightActions: [SwipeRowAction]? {
        didSet{
            setupActions(rightActions, forSide: .Right)
        }
    }
    
    var leftActions: [SwipeRowAction]? {
        didSet{
            setupActions(leftActions, forSide: .Left)
        }
    }
    
    
    
    
    // MARK: Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Public class methods
    
    class func closeAllCells() {
        self.closeAllCellsExcept(nil)
    }
    
    class func closeAllCellsExcept(cell:SwipeableTableViewCell?){
        NSNotificationCenter.defaultCenter().postNotificationName(SwipeableTableViewCell.CloseEvent, object: cell)
    }
    
    // MARK: Public methods
    
    func close(complete:(()->Void)?) {
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    
    func openSide(side:SwipeableTableViewCellSide) {
        self.openSide(side,animated:true)
    }
    
    func openSide(side:SwipeableTableViewCellSide,animated:Bool) {
        SwipeableTableViewCell.closeAllCellsExcept(self)
        switch side {
        case .Left:
            self.scrollView.setContentOffset(CGPointMake(-self.leftInset, 0), animated: animated)
        case .Right:
            self.scrollView.setContentOffset(CGPointMake(self.rightInset, 0), animated: animated)
            
        }
    }
    
    
    // MARK: Private func
    
    private func updateScrollContentInset(){
        // Update the scrollable areas outside the scroll view to fit the buttons.
        self.scrollView.contentInset = UIEdgeInsetsMake(0, self.leftInset, 0, self.rightInset)
    }
    
    private func setup() {
        // Create the scroll view which enables the horizontal swiping.
        let scrollView = UIScrollView(frame: self.contentView.bounds)
        scrollView.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        
        scrollView.delegate = self
        scrollView.scrollsToTop = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.scrollView = scrollView
        self.addSubview(scrollView)
        
        var contentBouds = self.contentView.bounds.size
        contentBouds.height = 0
        self.scrollView.contentSize = contentBouds
        self.backgroundColor = self.contentView.backgroundColor
        
        // Create the containers which will contain buttons on the left and right sides.
        self.buttonViews = [self.createButtonsView(),self.createButtonsView()]
        
        // Set up main content area.
        let contentView = UIView(frame:scrollView.bounds)
        contentView.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        contentView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(contentView)
        self.scrollViewContentView = contentView
        
        self.contentView.removeFromSuperview()
        self.scrollViewContentView.addSubview(self.contentView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleCloseEvent), name: SwipeableTableViewCell.CloseEvent, object: nil)
        
    }
    
    private func createButtonsView() -> UIView{
        let view = UIView(frame: CGRectMake(0,0,0,self.contentView.bounds.height))
        view.autoresizingMask = .FlexibleHeight
        self.scrollView.addSubview(view)
        return view
    }
    
    @objc
    private func handleCloseEvent(notification:NSNotification) {
        if notification.object != nil && self == notification.object as? SwipeableTableViewCell {
            return
        }
        self.close(nil)
    }
    
    private func setupActions(actions:[SwipeRowAction]?,forSide side:SwipeableTableViewCellSide){
        self.clearButtonsOnSide(side)
        guard let actions = actions else {
            return
        }
        
        for a in actions{
            let button = createButtonWithWidth(a.width, onSide: side)
            button.onTouchUpInside = a.action
            button.imageView?.contentMode = .ScaleAspectFit
            button.setImage(a.image, forState: .Normal)
            button.setTitle(a.title, forState: .Normal)
            button.backgroundColor = a.backgroundColor
        }
    }
    
    private func createButtonWithWidth(width:CGFloat,onSide side:SwipeableTableViewCellSide) -> SwipeableButton{
        let containter = self.buttonViews[side.rawValue]
        let size = containter.bounds.size
        
        let button = SwipeableButton(type:.Custom)
        button.autoresizingMask = .FlexibleHeight
        button.frame = CGRectMake(size.width, 0, width, size.height)
        
        
        // Resize the container to fit the new button.
        var x:CGFloat!
        switch side {
        case .Left:
            x = -(size.width + width)
        case .Right:
            x = self.contentView.bounds.width
        }
        
        containter.frame = CGRectMake(x, 0, size.width + width, size.height)
        containter.addSubview(button)
        
        // Update the scrollable areas outside the scroll view to fit the buttons.
        self.updateScrollContentInset()
        
        return button
    }
    
    private func clearButtonsOnSide(side:SwipeableTableViewCellSide){
        let containter:UIView = self.buttonViews[side.rawValue]
        let size = containter.bounds.size
        
        // Reset container width based on which side is it
        var x:CGFloat!
        switch side {
        case .Left:
            x = 0
        case .Right:
            x = self.contentView.bounds.width - containter.frame.width
        }
        containter.frame = CGRectMake(x, 0, 0, size.height)
        
        containter.removeAllSubviews()
        
        self.updateScrollContentInset()
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if ((self.leftInset == 0 && scrollView.contentOffset.x < 0) || (self.rightInset == 0 && scrollView.contentOffset.x > 0)) {
            scrollView.contentOffset = CGPointZero
        }
        
        let leftView = self.buttonViews[SwipeableTableViewCellSide.Left.rawValue]
        let rightView = self.buttonViews[SwipeableTableViewCellSide.Right.rawValue]
        if (scrollView.contentOffset.x < 0) {
            // Make the left buttons stay in place.
            leftView.frame = CGRectMake(scrollView.contentOffset.x, 0, self.leftInset, leftView.frame.size.height)
            leftView.hidden = false
            // Hide the right buttons.
            rightView.hidden = true
        } else if (scrollView.contentOffset.x > 0) {
            // Make the right buttons stay in place.
            rightView.frame = CGRectMake(self.contentView.bounds.size.width - self.rightInset + scrollView.contentOffset.x, 0,
                                         self.rightInset, rightView.frame.size.height)
            rightView.hidden = false
            // Hide the left buttons.
            leftView.hidden = true
        } else {
            leftView.hidden = true
            rightView.hidden = true
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        SwipeableTableViewCell.closeAllCellsExcept(self)
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x:CGFloat = scrollView.contentOffset.x
        let left = self.leftInset
        let right = self.rightInset
        if (left > 0 && (x < -left || (x < 0 && velocity.x < -OpenVelocityThreshold))) {
            targetContentOffset.memory.x = -left;
        } else if (right > 0 && (x > right || (x > 0 && velocity.x > OpenVelocityThreshold))) {
            targetContentOffset.memory.x = right;
        } else {
            targetContentOffset.memory = CGPointZero;
            
            // If the scroll isn't on a fast path to zero, animate it instead.
            let ms:CGFloat = x / -velocity.x;
            if (velocity.x == 0 || ms < 0 || ms > MaxCloseMilliseconds) {
                dispatch_async(dispatch_get_main_queue()){
                    scrollView.setContentOffset(CGPointZero, animated: true)
                }
            }
        }
    }
    
    // MARK: UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var contentBounds:CGSize = self.contentView.bounds.size;
        contentBounds.height = 0; // to be sure that ther wont be no vertical scrolling
        self.scrollView.contentSize = contentBounds;
        self.scrollView.contentOffset = CGPointZero;
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let xOffsetGreatestThanZero = scrollView.contentOffset.x != 0
        let xOffsetIsNotEqualToLeftInset = self.leftInset != fabs(scrollView.contentOffset.x)
        let xOffsetIsNotEqualToRightInset = self.rightInset != fabs(scrollView.contentOffset.x)
        
        if ((rightInset != 0 && !xOffsetIsNotEqualToRightInset ) || (leftInset != 0 && !xOffsetIsNotEqualToLeftInset)) {
            SwipeableTableViewCell.closeAllCells()
            return
        } else if (xOffsetGreatestThanZero && xOffsetIsNotEqualToLeftInset && xOffsetIsNotEqualToRightInset) {
            SwipeableTableViewCell.closeAllCells() //Check why is it not affect self
        } else {
            SwipeableTableViewCell.closeAllCells() //Check why is it not affect self
            super.touchesBegan(touches, withEvent: event)
        }
    }
 }
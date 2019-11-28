//
//  LoaderView.swift
//  SourcePointMetaApp
//
//  Created by Vilas on 3/26/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import UIKit

class LoaderView: UIView {

    // MARK: - Instance Properties
    
    /**
     *  Identifier to track how much strongly refered these LoaderView in App and how many relinquished ownership for this loader.
     */
    var retainCountValue : Int = 0
    
    var dummyView = UIView()
    
    // MARK: - IBoutlets
    @IBOutlet      var view : UIView!
    @IBOutlet weak var activity : UIActivityIndicatorView!
    @IBOutlet weak var activityContainerView : UIView!
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialUISetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialUISetUp()
    }
    
    // MARK: - LifeCycle Methods
    override func draw(_ rect: CGRect) {
        view.frame = bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.clear
        activityContainerView.layer.cornerRadius = 5
    }
    
    deinit {
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        return dummyView
    }
    
    // MARK: - Instance Methods
    
    /**
     Show Loader view on main window
     */
    func show (inView view : UIView) {
        
        if retainCountValue == 0 {
            activity.startAnimating()
            
            let leadingConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
            let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
            let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
            view.addSubview(self)
            view.addConstraints([leadingConstraint, topConstraint, trailingConstraint,bottomConstraint])
        }
        DispatchQueue.main.async {
            view.bringSubviewToFront(self)
        }
        
        retainCountValue += 1
    }
    
    /**
     Hide loader view from main window and decrease retain count
     */
    func hide() {
        
        if retainCountValue > 0 {
            retainCountValue -=  1
            if retainCountValue == 0 {
                activity.stopAnimating()
                removeFromSuperview()
            }
        }
    }
}

//// MARK: - LoaderView
extension LoaderView {
    
    func initialUISetUp() {
        
        Bundle.main.loadNibNamed("LoaderView", owner: self, options: nil)
        guard let content = view else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        content.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: content, attribute: .leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: content, attribute: .top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: content, attribute: .trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: content, attribute: .bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        addSubview(content)
        addConstraints([leadingConstraint, topConstraint, trailingConstraint,bottomConstraint])
    }
}


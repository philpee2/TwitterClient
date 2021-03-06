//
//  UserProfileHeaderView.swift
//  TwitterClient
//
//  Created by phil_nachum on 8/18/16.
//  Copyright © 2016 phil_nachum. All rights reserved.
//

import UIKit

class UserProfileHeaderView: UIView {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet var contentView: UIView!

    var user: User! {
        didSet {
            if let backgroundImageUrl = user.backgroundImageUrl {
                backgroundImage.setImageWithURL(backgroundImageUrl)
                // White text is usually more visible on a background image
                nameLabel.textColor = UIColor.whiteColor()
                screenNameLabel.textColor = UIColor.whiteColor()
            }
            profileImage.setImageWithURL(user.profileImageUrl)
            nameLabel.text = user.name
            screenNameLabel.text = "@\(user.screenName)"
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "UserProfileHeaderView", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)

        // custom initialization logic
    }

}

//
//  StoryboardPresentable.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 10.06.2021.
//

import UIKit

protocol StoryboardPresentable {
    /**
     Instantiates a new UIViewController from the Main storyboard. The View Controller storyboard identifier needs to be the same as it's name.
     
     - Returns: The instantiated `UIViewController`
     */
    static func instantiateFromStoryboard() -> Self?
}

extension StoryboardPresentable where Self: UIViewController {
    static func instantiateFromStoryboard() -> Self? {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        return storyboard.instantiateViewController(withIdentifier: className) as? Self
    }
}

//
//  ViewController.swift
//  Sunsetify
//
//  Created by Nguyen, Stephanie V on 2/8/25.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Create the SwiftUI view
        let contentView = SunsetView()
        
        // Create a UIHostingController with the SwiftUI view
        let hostingController = UIHostingController(rootView: contentView)
        
        // Add the hosting controller as a child view controller
        addChild(hostingController)
        hostingController.view.frame = view.bounds // Make it fill the screen
        view.addSubview(hostingController.view)
        
        // Notify the hosting controller that it was added
        hostingController.didMove(toParent: self)
    }


}


//
//  WeatherViewController.swift
//  Sunsetify
//
//  Created by Ajisegiri, Fareedah I on 2/8/25.
//

import UIKit
import SwiftUI

class WeatherViewController: UIViewController {

    @IBOutlet weak var sunsetImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sunsetImage.image = UIImage(named: "SunsetIcon")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

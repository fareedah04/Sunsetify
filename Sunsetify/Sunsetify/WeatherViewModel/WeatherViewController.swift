//
//  WeatherViewController.swift
//  Sunsetify
//
//  Created by Ajisegiri, Fareedah I on 2/8/25.
//

import UIKit
import SwiftUI

class WeatherViewController: UIViewController {
    var delegate: UIViewController!
    
    @IBOutlet weak var swiftUIViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.view.backgroundColor = .clear
        
//        // Create the SwiftUI view
//        let contentView = SunsetView()
    
        
        // Add SunsetView inside the UIView from Storyboard
        embedSwiftUIView()
        
        // Create a UIHostingController with the SwiftUI view
//        let hostingController = UIHostingController(rootView: contentView)
       
//        // Add the hosting controller as a child view controller
//        addChild(hostingController)
//        hostingController.view.frame = view.bounds // Make it fill the screen
//        view.addSubview(hostingController.view)
//   
//        
//        // Notify the hosting controller that it was added
//        hostingController.didMove(toParent: self)
//      
        // Do any additional setup after loading the view.
        setGradientBackground()
        addBlurEffect()
        addFloatingClouds()
    }
    
    private func embedSwiftUIView() {
            let contentView = SunsetView()
            let hostingController = UIHostingController(rootView: contentView)

            addChild(hostingController)
            hostingController.view.frame = swiftUIViewContainer.bounds
            hostingController.view.backgroundColor = .clear
            swiftUIViewContainer.addSubview(hostingController.view)
            hostingController.didMove(toParent: self)
        }
    private func setGradientBackground() {
        print("InsideSetGradient")

        self.view.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds

        gradientLayer.colors = [
            UIColor(red: 1.0, green: 0.65, blue: 0.7, alpha: 1.0).cgColor,  // Warm pink
            UIColor(red: 0.9, green: 0.7, blue: 0.9, alpha: 1.0).cgColor,  // Lavender
            UIColor(red: 1.0, green: 0.75, blue: 0.5, alpha: 1.0).cgColor,  // Peach
            UIColor(red: 1.0, green: 0.9, blue: 0.6, alpha: 1.0).cgColor   // Soft yellow
        ]

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    private func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light) // Use .dark for a darker effect
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.bounds
        blurView.alpha = 0.3 // Adjust for subtle effect
        self.view.insertSubview(blurView, at: 1)
    }

    private func addFloatingClouds() {
        let cloudImage = "cloud1" // Your single cloud image name

        // Define **fixed** Y positions to prevent overlap
        let cloudData: [(y: CGFloat, size: CGFloat, speed: Double)] = [
            (y: 100, size: 350, speed: 30), // High cloud, big, slow
            (y: 230, size: 400, speed: 50), // Middle cloud, large, medium speed
            (y: 330, size: 200, speed: 35), // Lower cloud, smaller
            (y: 380, size: 300, speed: 25), // Lower cloud, smaller
           
        ]

        for data in cloudData {
            let cloud = UIImageView(image: UIImage(named: cloudImage)) // Reuse the same image
            let width = data.size
            let height = data.size * 0.6 // Maintain aspect ratio
            
            let startX = -width // Start off-screen on the left
            let endX = self.view.bounds.width + width // Move off-screen to the right
            
            cloud.frame = CGRect(x: startX, y: data.y, width: width, height: height)
            cloud.alpha = 0.9 // Keep them visible but soft

            self.view.addSubview(cloud)
            animateCloud(cloud, toX: endX, duration: data.speed)
        }
    }



    private func animateCloud(_ cloud: UIImageView, toX endX: CGFloat, duration: Double) {
        UIView.animate(withDuration: duration,
                       delay: Double.random(in: 0...3), // Staggered start times
                       options: [.curveLinear, .repeat], // Repeat infinitely
                       animations: {
            cloud.frame.origin.x = endX // Move across the screen
        }, completion: nil)
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

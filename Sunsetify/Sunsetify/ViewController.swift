//
//  ViewController.swift
//  Sunsetify
//
//  Created by Nguyen, Stephanie V on 2/8/25.
//
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        setGradientBackground()
        addBlurEffect()
        addFloatingClouds()
//        
//        loginButton.setTitleColor(UIColor.white, for: .normal)  // Optional: Change text color
//        loginButton.backgroundColor = UIColor.systemYellow
//        loginButton.layer.cornerRadius = 10  // Optional: Rounded corners for a better look
//        loginButton.layer.masksToBounds = true
    
        
        // Create an image view with your image
           let imageView = UIImageView(image: UIImage(named: "Sunsetify"))  // Use the exact image name
           
           // Set the frame (position & size)
           imageView.frame = CGRect(x: 40, y: 100, width: 350, height: 350) // Adjust as needed
           
           // Optional: Keep aspect ratio
           imageView.contentMode = .scaleAspectFit
        print("pls load image")
           
           // Add the image to the view
           self.view.addSubview(imageView)
 
    }
    
    func styleButton(_ button: UIButton) {
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowRadius = 6
        button.setTitleColor(.white, for: .normal)
    
        
        // Gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 1.0, green: 0.7, blue: 0.5, alpha: 1.0).cgColor, // Peach
            UIColor(red: 1.0, green: 0.85, blue: 0.6, alpha: 1.0).cgColor // Soft yellow
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = button.bounds
        gradientLayer.cornerRadius = button.layer.cornerRadius
        button.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        styleButton(loginButton) // Call this to apply the gradient
    }


    private func setGradientBackground() {
        print("InsideSetGradient")

        self.view.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds

        // 🎨 Soft pastel sunset colors with yellow glow
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
            (y: 150, size: 400, speed: 40), // Middle cloud, large, medium speed
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


}

//
//  ViewController.swift
//  Sunsetify
//
//  Created by Nguyen, Stephanie V on 2/8/25.
//
import UIKit
import SwiftUI

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lasso: UIImageView!
    @IBOutlet weak var cowGirlHat: UIImageView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        username.delegate = self
        password.delegate = self
        
        setGradientBackground()
        addBlurEffect()
        addFloatingClouds()
        addBackgroundBox()
        styleTextField(username)
        styleTextField(password)
        animateFloatingEffect(cowGirlHat)
        animateFloatingEffect(lasso)



//        nameField.delegate = self

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
    
    func animateFloatingEffect(_ imageView: UIImageView) {
        let floatUp = CGAffineTransform(translationX: 0, y: -5) // Moves slightly up
        let floatDown = CGAffineTransform(translationX: 0, y: 5) // Moves slightly down
        
        UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: [.autoreverse, .repeat], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                imageView.transform = floatUp.rotated(by: -0.05) // Slight tilt left
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                imageView.transform = floatDown.rotated(by: 0.05) // Slight tilt right
            }
        })
    }


    
    func addBackgroundBox() {
        print("adding box")
        let backgroundBox = UIView()
        backgroundBox.backgroundColor = UIColor.white.withAlphaComponent(0.3) // Semi-transparent white
        backgroundBox.layer.cornerRadius = 20
        backgroundBox.layer.masksToBounds = true

        // Add shadow for depth
        backgroundBox.layer.shadowColor = UIColor.black.cgColor
        backgroundBox.layer.shadowOpacity = 0.1
        backgroundBox.layer.shadowOffset = CGSize(width: 2, height: 4)
        backgroundBox.layer.shadowRadius = 10

        backgroundBox.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backgroundBox)
        self.view.insertSubview(backgroundBox, belowSubview: loginButton)
        self.view.insertSubview(backgroundBox, belowSubview: password)


        // Apply constraints
        NSLayoutConstraint.activate([
            backgroundBox.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            backgroundBox.topAnchor.constraint(equalTo: username.topAnchor, constant: -30),
            backgroundBox.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            backgroundBox.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 30) // Adjusts height dynamically
        ])

        // Add blur effect
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        backgroundBox.addSubview(blurView)

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: backgroundBox.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: backgroundBox.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: backgroundBox.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: backgroundBox.bottomAnchor)
        ])
    }




    func styleTextField(_ textField: UITextField) {
        textField.layer.cornerRadius = textField.frame.height / 2  // Fully rounded
        textField.layer.masksToBounds = true  // Ensures content is clipped inside the rounded
        
        textField.layer.cornerRadius = 15
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.white.cgColor
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        textField.textColor = .white
        textField.font = UIFont(name: "Avenir-Book", size: 18)
        
        // Add left padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        // Add subtle shadow
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowOffset = CGSize(width: 2, height: 2)
        textField.layer.shadowRadius = 5
    }

    
    func styleButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.height / 2  // Fully rounded
        button.layer.masksToBounds = true  // Ensures content is clipped inside the rounded shape
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.white.cgColor
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
    
    
    // Called when 'return' key pressed

    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user clicks on the view outside of the UITextField

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    


}

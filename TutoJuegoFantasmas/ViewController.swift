//
//  ViewController.swift
//  TutoJuegoFantasmas
//
//  Created by Nicolas Novalbos on 18/6/18.
//  Copyright © 2018 Nicolás Novalbos. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet var sceneView: ARSKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         Esto asegurará que nuestra escena llene toda la vista y, por lo tanto, toda la pantalla (recuerde que el ARSKView definido en Main.storyboard ocupa toda la pantalla). Esto también ayudará a colocar las etiquetas del juego en la sección inferior izquierda de la pantalla, con las coordenadas de posición definidas en la escena.
         */
        
     
        
        
        // codigo que viene por defecto
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
     //   sceneView.showsFPS = true
      //  sceneView.showsNodeCount = true
        /*
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
        */
        
        let scene = Scene(size: sceneView.bounds.size)
        scene.scaleMode = .resizeFill
        sceneView.presentScene(scene)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSKViewDelegate
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        
        let ghostId = randomInt(min: 1, max: 3)
        let node = SKSpriteNode(imageNamed: "ghost\(ghostId)")
        node.name = "ghost"
        
        return node
        
        /* venia por defecto
        // Create and configure a node for the anchor added to the view's session.
        let labelNode = SKLabelNode(text: "👾")
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        return labelNode;
        */
    }
    
    func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

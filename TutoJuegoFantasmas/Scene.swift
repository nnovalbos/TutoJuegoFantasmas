//
//  Scene.swift
//  TutoJuegoFantasmas
//
//  Created by Nicolas Novalbos on 18/6/18.
//  Copyright © 2018 Nicolás Novalbos. All rights reserved.
//

import SpriteKit
import ARKit

class Scene: SKScene {
    
    let ghostsLabel = SKLabelNode(text: "Ghosts")
    let numberOfGhostsLabel = SKLabelNode(text: "0")
    var creationTime : TimeInterval = 0
    var ghostCount = 0 {
        didSet {
            self.numberOfGhostsLabel.text = "\(ghostCount)"
        }
    }
    
    //sonido
    let killSound = SKAction.playSoundFileNamed("ghost", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        // Setup your scene here
        ghostsLabel.fontSize = 20
        ghostsLabel.fontName = "DevanagariSangamMN-Bold"
        ghostsLabel.color = .white
        ghostsLabel.position = CGPoint(x: 40, y: 50)
        addChild(ghostsLabel)
        
        numberOfGhostsLabel.fontSize = 30
        numberOfGhostsLabel.fontName = "DevanagariSangamMN-Bold"
        numberOfGhostsLabel.color = .white
        //posición inferior izq
        numberOfGhostsLabel.position = CGPoint(x: 40, y: 10)
        addChild(numberOfGhostsLabel)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        if currentTime > creationTime {
            createGhostAnchor()
            creationTime = currentTime + TimeInterval(randomFloat(min: 3.0, max: 6.0))
        }
    }
    
    func createGhostAnchor(){
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        let _360degrees = 2.0 * Float.pi

        /* SCNMatrix4MakeRotation devuelve una matriz que describe una transformación de rotación. El primer parámetro representa el ángulo de rotación, en radianes. La expresión _360degrees * randomFloat (min: 0.0, max: 1.0) proporciona un ángulo aleatorio de 0 a 360 grados.
         
         El resto de los parámetros de SCNMatrix4MakeRotation representan los componentes X, Y y Z del eje de rotación, respectivamente, por eso estamos pasando 1 como el parámetro que corresponde a X en la primera llamada y 1 como el parámetro que corresponde a Y en el segunda llamada.
         
         El resultado de SCNMatrix4MakeRotation se convierte en una matriz de 4 × 4 utilizando la estructura simd_float4x4.
         
         Podemos combinar ambas matrices de rotación con una operación de multiplicación
         
         */
        let rotateX = simd_float4x4(SCNMatrix4MakeRotation(_360degrees * randomFloat(min: 0.0, max: 1.0), 1, 0, 0))
        
        let rotateY = simd_float4x4(SCNMatrix4MakeRotation(_360degrees * randomFloat(min: 0.0, max: 1.0), 0, 1, 0))
        
        let rotation = simd_mul(rotateX, rotateY)
        /* Luego, creamos una matriz de traducción en el eje Z con un valor aleatorio entre -1 y -2 metros: */
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1 - randomFloat(min: 0.0, max: 1.0)
        
        //Combina las matrices de rotación y traducción:
        let transform = simd_mul(rotation, translation)
        
       // Crea y agrega el anclaje a la sesión
        let anchor = ARAnchor(transform: transform)
        sceneView.session.add(anchor: anchor)
        //sumamos 1 fantasma
         ghostCount += 1
        
    }
    
    /*
     se ejecuta cuando el usuario toca un fantasma para eliminarlo. Reemplace el método touchesBegan para obtener el objeto táctil primero:
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        //obtenga la ubicación del toque en la escena AR:
         let location = touch.location(in: self)
        
        //Obtenga los nodos en esa ubicación:
        
         let hit = nodes(at: location)
        
        //Obtenga el primer nodo (si lo hay) y verifique si el nodo representa un fantasma (recuerde que las etiquetas también son un nodo):
        
        if let node = hit.first {
            if node.name == "ghost" {
                /*Si ese es el caso, agrupe las acciones de fundido de salida y de sonido, cree una secuencia de acción, ejecútela y disminuya el contador de fantasmas:*/
                
                let fadeOut = SKAction.fadeOut(withDuration: 0.5)
                let remove = SKAction.removeFromParent()
                
                
                // Group the fade out and sound actions
                let groupKillingActions = SKAction.group([fadeOut, killSound])
                // Create an action sequence
                let sequenceAction = SKAction.sequence([groupKillingActions, remove])
                
                // Excecute the actions
                node.run(sequenceAction)
                
                // Update the counter
                ghostCount -= 1
            }
        }
        
    }
    
    
    func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        // Create anchor using the camera's current position
        if let currentFrame = sceneView.session.currentFrame {
            
            // Create a transform with a translation of 0.2 meters in front of the camera
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.2
            let transform = simd_mul(currentFrame.camera.transform, translation)
            
            // Add a new anchor to the session
            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
        }
    }
    */
}

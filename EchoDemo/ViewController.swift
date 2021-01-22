//
//  ViewController.swift
//  EchoAR-iOS-SceneKit
//
//  Copyright © echoAR, Inc. 2018-2020.
//
//  Use subject to the Terms of Service available at https://www.echoar.xyz/terms,
//  or another agreement between echoAR, Inc. and you, your company or other organization.
//
//  Unless expressly provided otherwise, the software provided under these Terms of Service
//  is made available strictly on an “AS IS” BASIS WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED.
//  Please review the Terms of Service for details on these and other terms and conditions.
//
//  Created by Alexander Kutner.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var e:EchoAR!;
    
    //variables to store data for horizontal planes
    var planeColor: UIColor?
    var planeColorOff: UIColor?
    var myPlaneNode: SCNNode?
    var myPlanes: [SCNNode] = []
    
    //echoAR entry id's for 3D models for app
    let foxId = "5b216f6f-bc50-483c-b943-5a6bb17a5869"
    let japanFoxId = "46319048-8e35-42a0-85d6-68a4ae419342"
    let corgiId = "4a7feba6-7571-45bb-a608-81e8bdfe7f27"
    let ferretId = "4bc37212-5f35-41cf-9c4f-771ff33cb5f0"
    let parrotId = "c0c755eb-afb6-4954-a83a-2d138158b0be"
    
    @IBOutlet weak var foxButton: UIButton!
    @IBOutlet weak var japanButton: UIButton!
    @IBOutlet weak var Corgi: UIButton!
    @IBOutlet weak var Ferret: UIButton!
    @IBOutlet weak var Parrot: UIButton!
    
    //selected index and id, for the object a user has selected
    //using choice buttons
    var selectedId: String?
    var selectedInd = 0
    
    //array of the echoAR entry id's of 3D models
    var idArr: [String]?
    
    //constants to scale down the nodes, when first added to sceneView
    var scaleConstants: [CGFloat]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set all model choice button alpha's to the deselect state
        resetChoiceButtonAlphas()
        
        //select the FoxId, by making it's entyr id the selected id
        //and by updating it's button alpha to the selected state
        selectedId = foxId
        foxButton.alpha = 1.0
        
        // Set the view's delegate
        sceneView.delegate = self
        //let scene = SCNScene(named: "art.scnassets/River otter.usdz")!
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        //array of all entry id's of models users can add
        idArr = [foxId, japanFoxId, corgiId, ferretId, parrotId]
        
        //default scale constants for the objects (reducing their size to start)
        //(if you chose entries different from the suggested,
        //update these constants to match the size of the entries chosen)
        scaleConstants = [0.009, 0.0004, 0.002, 0.0001, 0.004]

        let e = EchoAR();
        
        //choose a color to use for the plane
        planeColor = UIColor(red: CGFloat(102.0/255) , green: CGFloat(189.0/255), blue: CGFloat(60.0/255), alpha: CGFloat(0.6))
        planeColorOff = UIColor(red: CGFloat(102.0/255) , green: CGFloat(189.0/255), blue: CGFloat(60.0/255), alpha: CGFloat(0.0))

        
        let scene = SCNScene()
        
        // can load all nodes
//        e.loadAllNodes(){ (nodes) in
//            for node in nodes{
//                scene.rootNode.addChildNode(node);
//            }
//        }
//
        // Set the scene to the view
        sceneView.scene=scene;
        
        //create and add a recognizer to respond to taps on the scene view

        //add nodes
        e.loadSceneFromEntryID(entryID: foxId, completion: {selectedScene in
            //make sure the scene has a scene node
            guard let selectedNode = selectedScene.rootNode.childNodes.first else {return}
            //set the position of the node
            selectedNode.position = SCNVector3(0,0,0)
            //scale down the node using our scale constants
            let action = SCNAction.scale(by: scaleConstants![selectedInd], duration: 0.3)
            selectedNode.runAction(action)
            //set the name of the node (just in case we ever need it)
            selectedNode.name = idArr![selectedInd]
            
            //add the node to our scene
            sceneView.scene.rootNode.addChildNode(selectedNode)
            
        })
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
       
        sceneView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //when the view appears, present an alert to the user
        //letting them know to scan a horizontal surface
        let alert = UIAlertController(title: "Scan And Get Started", message: "Move your phone around to scan a horizontal plane", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func resetChoiceButtonAlphas(){
        //when buttons are not selected, dim them
        foxButton.alpha = 0.3
        japanButton.alpha = 0.3
        Corgi.alpha = 0.3
        Ferret.alpha = 0.3
        Parrot.alpha = 0.3
    }
    
}

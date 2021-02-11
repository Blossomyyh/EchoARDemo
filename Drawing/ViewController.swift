//
//  ViewController.swift


import UIKit
import ARKit
import RGSColorSlider

@available(iOS 13.0, *)
class ViewController: UIViewController, ARSCNViewDelegate {
    
    
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
    
    @IBOutlet var btnReset: UIButton!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var btnDraw: UIButton!
    @IBOutlet var settingView: UIView!
    @IBOutlet var lblLineWidth: UILabel!
    @IBOutlet var btnEraser: UIButton!
    
    let config = ARWorldTrackingConfiguration()
    var isDraw: Bool = false
    var isErase: Bool = false
    var lineWidth: CGFloat!
    var lineColour: UIColor!
    
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
        sceneView.delegate = self
        //set default value of sliders
        lineWidth = 2
        lineColour = UIColor(red: 0, green: 119.0/255.0, blue: 1, alpha: 1)
        sceneView.session.run(config)
        
        //select the FoxId, by making it's entyr id the selected id
        //and by updating it's button alpha to the selected state
        selectedId = foxId
        foxButton.alpha = 1.0
        
        
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

        
        //add nodes
        e.loadSceneFromEntryID(entryID: foxId, completion: {selectedScene in
            //make sure the scene has a scene node
            guard let selectedNode = selectedScene.rootNode.childNodes.first else {return}
            //set the position of the node
            guard let pointOfView = sceneView.pointOfView else { return }
            let transform = pointOfView.transform
            selectedNode.position = SCNVector3(x: transform.m41, y: transform.m42, z: transform.m43-5)
            
//                SCNVector3(0,0,0)
            //scale down the node using our scale constants
            let action = SCNAction.scale(by: scaleConstants![selectedInd], duration: 0.3)
            selectedNode.runAction(action)
            //set the name of the node (just in case we ever need it)
            selectedNode.name = idArr![selectedInd]
            
            //add the node to our scene
            sceneView.scene.rootNode.addChildNode(selectedNode)
            
        })
        
        //create and add a recognizer to respond to finger pinchs on the scene view
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(pinchRecognizer:)))
        sceneView.addGestureRecognizer(pinchRecognizer)

        
        
    }
    
    //handlePinch(panGesture:) - takes a UIPinchGestureRecognizer as an argument
    //called whenever a user does a two finger pinch
    //calls the doScale method
    @objc func handlePinch(pinchRecognizer: UIPinchGestureRecognizer){
        //call do scale to scale node on user pinch gesture
        doScale(recognizer: pinchRecognizer)
    }

    //doScale(recognizer:) - takes a UIPinchGestureRecognizer as an argument
    //scales a node to the sceneView based on the state of the gesture recognizer
    func doScale(recognizer: UIPinchGestureRecognizer){
        //get the location of the pinch
        let location = recognizer.location(in: sceneView)
        
        //get the node touched by pinch
        guard let hitNodeResult = sceneView.hitTest(location, options: nil).first else {return}
        if(isPlane(node: hitNodeResult.node)){
            return
        }
        //if the pinch has begun, or continues
        if recognizer.state == .began || recognizer.state == .changed {
            //scale the touched node
            let action = SCNAction.scale(by: recognizer.scale, duration: 0.3)
            hitNodeResult.node.runAction(action)
            recognizer.scale = 1.0
        }
    }
    
    //isPlane(node:): takes an SCNNode as an argument
    //returns true if the node is named "plain" otherwise returns false
    func isPlane(node: SCNNode) -> Bool {
        guard  let name = node.name else {
            return false
        }
        if name == "plain"{
            return true
        }
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func drawingAction(_ sender: Any) {
        if btnDraw.imageView?.image == #imageLiteral(resourceName: "drawing_pen") {
            isDraw = true
            btnEraser.isHidden = true
            btnReset.isHidden = true
            btnDraw.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
        } else {
            isDraw = false
            btnEraser.isHidden = false
            btnReset.isHidden = false
            btnDraw.setImage(#imageLiteral(resourceName: "drawing_pen"), for: .normal)
        }
    }
    
    @IBAction func openSettingAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.settingView.isHidden = (self.settingView.isHidden) ? false : true
        }
    }
    
    @IBAction func resetDrawing(_ sender: Any) {
        DispatchQueue.main.async {
            self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                node.removeFromParentNode()
            })
        }
    }
    
    @IBAction func changeLineWidth(_ sender: Any) {
        lineWidth = CGFloat((sender as! UISlider).value)
        lblLineWidth.text = "Line Width :- \(String(format: "%.1f", lineWidth!)) cm"
    }
    
    @IBAction func changeLineColour(_ sender: Any) {
        lineColour = (sender as! RGSColorSlider).color!
    }
    
    @IBAction func eraseDrawing(_ sender: Any) {
        isErase = isErase ? false : true
        btnDraw.isHidden = isErase ? true : false
        btnReset.isHidden = isErase ? true : false
        if !isErase {
            DispatchQueue.main.async {
                self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                    if node.name == "eraser" {
                        node.removeFromParentNode()
                    }
                }
            }
        }
    }
    
    @IBAction func undoDraw(_ sender: Any) {
    }
    
    @IBAction func redoDraw(_ sender: Any) {
    }
    
    //MARK:- Render Delegate
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else { return }
        let transform = pointOfView.transform
        let orientation = SCNVector3(x: -transform.m31, y: -transform.m32, z: -transform.m33)
        let location = SCNVector3(x: transform.m41, y: transform.m42, z: transform.m43)
        let currentPosition = orientation + location
        if isDraw { //drawing starts
            let drawNode = SCNNode(geometry: SCNSphere(radius: lineWidth/200))
            drawNode.geometry?.firstMaterial?.diffuse.contents = lineColour
            drawNode.position = currentPosition
            sceneView.scene.rootNode.addChildNode(drawNode)
        } else if isErase {
            DispatchQueue.main.async {
                let eraser = SCNNode(geometry: SCNPlane(width: 0.1, height: 0.1))
                eraser.name = "eraser"
                eraser.position = currentPosition
                eraser.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "eraser")
                
                self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                    if node.position == currentPosition || node.name == "eraser" {
                        node.removeFromParentNode()
                    }
                }
                self.sceneView.scene.rootNode.addChildNode(eraser)
            }
        } else {
            DispatchQueue.main.async {
                let pointerNode = SCNNode(geometry: SCNSphere(radius: self.lineWidth/200))
                pointerNode.name = "pointer"
                self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                    if node.name == "pointer" {
                        node.removeFromParentNode()
                    }
                }
                pointerNode.geometry?.firstMaterial?.diffuse.contents = self.lineColour
                pointerNode.position = currentPosition
                self.sceneView.scene.rootNode.addChildNode(pointerNode)
            }
        }
    }
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

func ==(left: SCNVector3, right: SCNVector3) -> Bool {
    if String(format: "%.1f",left.x) == String(format: "%.1f",right.x) {
        if String(format: "%.1f",left.y) == String(format: "%.1f",right.y) {
            if String(format: "%.1f",left.z) == String(format: "%.1f",right.z) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    } else {
        return false
    }
}


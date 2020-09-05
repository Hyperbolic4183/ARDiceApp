//
//  ViewController.swift
//  ARtest
//
//  Created by 大塚周 on 2020/08/29.
//  Copyright © 2020 大塚周. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController,ARSCNViewDelegate {

    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var backButtin: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var diceCreateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    let configuration = ARWorldTrackingConfiguration()
    var x = 0.0
    var y = 0.0
    var z = 0.0
    
    var angle = 0.0
    var scene = TestScene.init(kind: "male")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.delegate = self
        self.sceneView.scene = scene
        self.configuration.planeDetection = .horizontal
        self.configuration.frameSemantics = .personSegmentationWithDepth//okuru-jonn
        self.sceneView.debugOptions = [SCNDebugOptions.showWorldOrigin]
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.session.run(configuration)
        self.backButtin.layer.cornerRadius = 10
        self.forwardButton.layer.cornerRadius = 10
        self.diceCreateButton.layer.cornerRadius = 10
        self.deleteButton.layer.cornerRadius = 10
        self.rightButton.layer.cornerRadius = 10
        self.leftButton.layer.cornerRadius = 10
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
        print("pause")
    }
    
    
    func createBox(hitTestResult: ARHitTestResult){
        
        if (self.sceneView.scene.rootNode.childNode(withName: "box", recursively: true) != nil) {
            self.sceneView.scene.rootNode.enumerateChildNodes{ ( node,stop )in
                node.removeFromParentNode()
                }
            //2回目なら呼ばれる
        }
        
        let transform = hitTestResult.worldTransform
        let thirdColumn = transform.columns.3
        let boxNode = scene.boxNode
        let planeDice = scene.planeDice
//        if let camera = self.sceneView.pointOfView {
//            boxNode.eulerAngles = SCNVector3(0,camera.eulerAngles.y + Float(180.degreeToRadians),0)
//        }
        
        boxNode.geometry?.firstMaterial?.lightingModel = .constant
        boxNode.position = SCNVector3(thirdColumn.x,thirdColumn.y,thirdColumn.z)
        //sceneView.scene.rootNode.addChildNode(boxNode)
        planeDice.position = SCNVector3(thirdColumn.x,thirdColumn.y,thirdColumn.z)
        sceneView.scene.rootNode.addChildNode(planeDice)
        
        self.x = Double(thirdColumn.x)
        self.y = Double(thirdColumn.y)
        self.z = Double(thirdColumn.z)
    }
    
    
    
    func createPlane(planeAnchor: ARPlaneAnchor) -> SCNNode{
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let planeNode = SCNNode(geometry: plane)
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0)
        planeNode.geometry?.firstMaterial?.isDoubleSided = true
        planeNode.position = SCNVector3(planeAnchor.center.x,planeAnchor.center.y,planeAnchor.center.z)
        planeNode.eulerAngles = SCNVector3(90.degreeToRadians,0,0)
        return planeNode
    }
    
    func light() -> SCNNode {
        let ambientLight = SCNLight()
        ambientLight.type = .omni
        ambientLight.intensity = 0.02
        ambientLight.temperature = 0
        ambientLight.castsShadow = true
        
        let ambientLightNode = SCNNode()
        ambientLightNode.position = SCNVector3(0.1,0.1,-0.1)
        ambientLightNode.eulerAngles = SCNVector3(0,0,0)
        return ambientLightNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        self.sceneView.scene.rootNode.addChildNode(createPlane(planeAnchor: planeAnchor))
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        //print("update")
        node.enumerateChildNodes{ (childNode, _) in
            childNode.removeFromParentNode()
        }
        let planeNode = createPlane(planeAnchor: planeAnchor)
        node.addChildNode(planeNode)
    }
    
    @IBAction func dicecreateButton(_ sender: Any) {
        let centerPositionX = self.sceneView.bounds.width/2
        let centerPositionY = self.sceneView.bounds.height/2
        let centerLocation = CGPoint(x: centerPositionX, y: centerPositionY)
        let hitTest = sceneView.hitTest(centerLocation, types: .existingPlaneUsingExtent)
        if !hitTest.isEmpty {
            print("hit")
            self.createBox(hitTestResult: hitTest.first!)
            
        } else {
            print("don't hit")
        }
        
    }
    @IBAction func leftButton(_ sender: Any) {
        scene.emptyNode.position = SCNVector3(x: scene.planeDice.worldPosition.x-0.025,y: scene.planeDice.worldPosition.y-0.025,z: scene.planeDice.worldPosition.z)
        
        scene.emptyNode.addChildNode(scene.planeDice)
        scene.planeDice.worldPosition = SCNVector3(x,y,z)
        
        let rotateAnimation = SCNAction.rotate(by: CGFloat(Float.pi/2), around: SCNVector3(0,0,1), duration: 0.1)
        scene.emptyNode.runAction(rotateAnimation)
        x -= 0.05
    }
    
    @IBAction func rightButton(_ sender: Any) {
        
        scene.emptyNode.position = SCNVector3(x: scene.planeDice.worldPosition.x+0.025,y: scene.planeDice.worldPosition.y-0.025,z: scene.planeDice.worldPosition.z)
        
        scene.emptyNode.addChildNode(scene.planeDice)
        scene.planeDice.worldPosition = SCNVector3(x,y,z)
        let rotateAnimation = SCNAction.rotate(by: -CGFloat(Float.pi/2), around: SCNVector3(0,0,1), duration: 0.1)
        scene.emptyNode.runAction(rotateAnimation)
        x += 0.05
        
        let a = SCNNode()
        let b = SCNPlane(width: 0.05, height: 0.05)
        a.geometry = b
        a.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect1")
        a.position = SCNVector3(x-0.05,y-0.025,z)
        a.eulerAngles = SCNVector3(-90.degreeToRadians,0,0)
        scene.rootNode.addChildNode(a)
        
    }
    @IBAction func forwardButton(_ sender: Any) {
        scene.emptyNode.position = SCNVector3(x: scene.planeDice.worldPosition.x,y: scene.planeDice.worldPosition.y-0.025,z: scene.planeDice.worldPosition.z+0.025)
        scene.emptyNode.addChildNode(scene.planeDice)
        scene.planeDice.worldPosition = SCNVector3(x,y,z)
        let rotateAnimation = SCNAction.rotate(by: CGFloat(Float.pi/2), around: SCNVector3(1,0,0), duration: 0.1)
        scene.emptyNode.runAction(rotateAnimation)
        z += 0.05
    }
    @IBAction func backButton(_ sender: Any) {
        scene.emptyNode.position = SCNVector3(x: scene.planeDice.worldPosition.x,y: scene.planeDice.worldPosition.y-0.025,z: scene.planeDice.worldPosition.z-0.025)
        scene.emptyNode.addChildNode(scene.planeDice)
        scene.planeDice.worldPosition = SCNVector3(x,y,z)
        let rotateAnimation = SCNAction.rotate(by: -CGFloat(Float.pi/2), around: SCNVector3(1,0,0), duration: 0.1)
        scene.emptyNode.runAction(rotateAnimation)
        z -= 0.05
    }
    
    func rightrotate(node: SCNNode) {
        let angle = 90.degreeToRadians
        node.eulerAngles = SCNVector3(0,0,-angle)
    }
    @IBAction func changeKind(_ sender: UISwitch) {
        if sender.isOn {
            self.sceneView.scene.rootNode.enumerateChildNodes{ ( node,stop )in
            node.removeFromParentNode()
            }
             scene.kind = "male"
            self.scene = TestScene.init(kind: "male")
            self.sceneView.scene = scene
            
            let centerPositionX = self.sceneView.bounds.width/2
            let centerPositionY = self.sceneView.bounds.height/2
            let centerLocation = CGPoint(x: centerPositionX, y: centerPositionY)
            let hitTest = sceneView.hitTest(centerLocation, types: .existingPlaneUsingExtent)
            if !hitTest.isEmpty {
                print("hit")
                self.createBox(hitTestResult: hitTest.first!)
            } else {
                print("don't hit")
            }
        }
        else
        {
            self.sceneView.scene.rootNode.enumerateChildNodes{ ( node,stop )in
            node.removeFromParentNode()
            }
            scene.kind = "male"
            self.scene = TestScene.init(kind: "female")
            self.sceneView.scene = scene

            let centerPositionX = self.sceneView.bounds.width/2
            let centerPositionY = self.sceneView.bounds.height/2
            let centerLocation = CGPoint(x: centerPositionX, y: centerPositionY)
            let hitTest = sceneView.hitTest(centerLocation, types: .existingPlaneUsingExtent)
            if !hitTest.isEmpty {
                print("hit")
                self.createBox(hitTestResult: hitTest.first!)
                
            } else {
                print("don't hit")
            }
            
        }
    }
    
    
}

extension Int {
    var degreeToRadians: Double { return Double(self) * .pi/180 }
}

class TestScene: SCNScene {
    
    var boxNode = SCNNode()
    var emptyNode = SCNNode()
    
    var planeDice = SCNNode()
    var plane1 = SCNNode()
    var plane2 = SCNNode()
    var plane3 = SCNNode()
    var plane4 = SCNNode()
    var plane5 = SCNNode()
    var plane6 = SCNNode()
    
    
   var kind = "male"
   let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
    
    init(kind: String) {
        super.init()
        self.kind = kind
        print("イニシャライズが行われました")
        self.setUpScene(kind: kind)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpScene(kind: String) {
        
       
        if kind == "male" {
         print("種類は\(kind)です")
            makeplaneDice()
        } else {
             print("種類は\(kind)です")
            makeplaneDiceFemale()
        }

        self.rootNode.addChildNode(emptyNode)
    }
    
    func makeplaneDice() {
        let plane1 = SCNPlane(width: 0.05, height: 0.05)
        let plane2 = SCNPlane(width: 0.05, height: 0.05)
        let plane3 = SCNPlane(width: 0.05, height: 0.05)
        let plane4 = SCNPlane(width: 0.05, height: 0.05)
        let plane5 = SCNPlane(width: 0.05, height: 0.05)
        let plane6 = SCNPlane(width: 0.05, height: 0.05)
        
        
        self.plane1.geometry = plane1
        self.plane2.geometry = plane2
        self.plane3.geometry = plane3
        self.plane4.geometry = plane4
        self.plane5.geometry = plane5
        self.plane6.geometry = plane6
        
        self.plane1.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect1")
        self.plane2.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect2")
        self.plane3.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect3")
        self.plane4.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect4")
        self.plane5.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect5")
        self.plane6.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect6")
        
        
        
        self.planeDice.addChildNode(self.plane1)
        self.planeDice.addChildNode(self.plane2)
        self.planeDice.addChildNode(self.plane3)
        self.planeDice.addChildNode(self.plane4)
        self.planeDice.addChildNode(self.plane5)
        self.planeDice.addChildNode(self.plane6)
        
        self.plane1.position = SCNVector3(0,0.025,0)
        self.plane1.eulerAngles = SCNVector3(-90.degreeToRadians,0,0)
        
        self.plane2.position = SCNVector3(0,0,0.025)
        self.plane2.eulerAngles = SCNVector3(0,0,0)
        
        self.plane4.position = SCNVector3(0.025,0,0)
        self.plane4.eulerAngles = SCNVector3(0,90.degreeToRadians,0)
        
        self.plane3.position = SCNVector3(-0.025,0,0)
        self.plane3.eulerAngles = SCNVector3(0,-90.degreeToRadians,0)
        
        self.plane5.position = SCNVector3(0,0,-0.025)
        self.plane5.eulerAngles = SCNVector3(180.degreeToRadians,0,0)
        
        self.plane6.position = SCNVector3(0,-0.025,0)
        self.plane6.eulerAngles = SCNVector3(90.degreeToRadians,0,0)
    }
    
    func makeplaneDiceFemale() {
        let plane1 = SCNPlane(width: 0.05, height: 0.05)
        let plane2 = SCNPlane(width: 0.05, height: 0.05)
        let plane3 = SCNPlane(width: 0.05, height: 0.05)
        let plane4 = SCNPlane(width: 0.05, height: 0.05)
        let plane5 = SCNPlane(width: 0.05, height: 0.05)
        let plane6 = SCNPlane(width: 0.05, height: 0.05)
        
        
        self.plane1.geometry = plane1
        self.plane2.geometry = plane2
        self.plane3.geometry = plane3
        self.plane4.geometry = plane4
        self.plane5.geometry = plane5
        self.plane6.geometry = plane6
        
        self.plane1.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect1")
        self.plane2.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect2")
        self.plane3.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect3")
        self.plane4.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect4")
        self.plane5.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect5")
        self.plane6.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect6")
        
        
        
        self.planeDice.addChildNode(self.plane1)
        self.planeDice.addChildNode(self.plane2)
        self.planeDice.addChildNode(self.plane3)
        self.planeDice.addChildNode(self.plane4)
        self.planeDice.addChildNode(self.plane5)
        self.planeDice.addChildNode(self.plane6)
        
        self.plane1.position = SCNVector3(0,0.025,0)
        self.plane1.eulerAngles = SCNVector3(-90.degreeToRadians,0,0)
        
        self.plane2.position = SCNVector3(0,0,0.025)
        self.plane2.eulerAngles = SCNVector3(0,0,0)
        
        self.plane3.position = SCNVector3(0.025,0,0)
        self.plane3.eulerAngles = SCNVector3(0,90.degreeToRadians,0)
        
        self.plane4.position = SCNVector3(-0.025,0,0)
        self.plane4.eulerAngles = SCNVector3(0,-90.degreeToRadians,0)
        
        self.plane5.position = SCNVector3(0,0,-0.025)
        self.plane5.eulerAngles = SCNVector3(180.degreeToRadians,0,0)
        
        self.plane6.position = SCNVector3(0,-0.025,0)
        self.plane6.eulerAngles = SCNVector3(90.degreeToRadians,0,0)
    }
//
//    func diceMale() {
//        let m1 = SCNMaterial()
//        let m2 = SCNMaterial()
//        let m3 = SCNMaterial()
//        let m4 = SCNMaterial()
//        let m5 = SCNMaterial()
//        let m6 = SCNMaterial()
//
//        m1.diffuse.contents = UIImage(named: "rect2")
//        m2.diffuse.contents = UIImage(named: "rect3")
//        m3.diffuse.contents = UIImage(named: "rect5")
//        m4.diffuse.contents = UIImage(named: "rect4")
//        m5.diffuse.contents = UIImage(named: "rect1")
//        m6.diffuse.contents = UIImage(named: "rect6")
//
//        box.materials = [m1,m2,m3,m4,m5,m6]
//
//    }
//
//    func dicefemale() {
//        let m1 = SCNMaterial()
//        let m2 = SCNMaterial()
//        let m3 = SCNMaterial()
//        let m4 = SCNMaterial()
//        let m5 = SCNMaterial()
//        let m6 = SCNMaterial()
//
//        m1.diffuse.contents = UIImage(named: "rect2")
//        m2.diffuse.contents = UIImage(named: "rect4")
//        m3.diffuse.contents = UIImage(named: "rect5")
//        m4.diffuse.contents = UIImage(named: "rect3")
//        m5.diffuse.contents = UIImage(named: "rect1")
//        m6.diffuse.contents = UIImage(named: "rect6")
//
//        box.materials = [m1,m2,m3,m4,m5,m6]
//
//    }
    
}

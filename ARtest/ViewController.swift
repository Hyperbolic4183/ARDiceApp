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
    var x = 0.0 //boxNodeの座標を表す変数
    var y = 0.0
    var z = 0.0
    
    var duration = 0.1 //アニメーションにかける時間
    
    var planeNode1 = SCNNode() //サイコロの面を表すSCNNode
    var planeNode2 = SCNNode()
    var planeNode3 = SCNNode()
    var planeNode4 = SCNNode()
    var planeNode5 = SCNNode()
    var planeNode6 = SCNNode()
    
    let plane1 = SCNPlane(width: 0.05, height: 0.05)
    let plane2 = SCNPlane(width: 0.05, height: 0.05)
    let plane3 = SCNPlane(width: 0.05, height: 0.05)
    let plane4 = SCNPlane(width: 0.05, height: 0.05)
    let plane5 = SCNPlane(width: 0.05, height: 0.05)
    let plane6 = SCNPlane(width: 0.05, height: 0.05)
    
    var angle: Double = 0.0
    var kind = "male"
    
    var scene = TestScene.init(kind: "male")
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConfiguration()
        setUpButton()
        setUpNode()
    }
    //コンフィグレーションを行う関数
    func setUpConfiguration() {
        overrideUserInterfaceStyle = .light
        self.sceneView.delegate = self
        self.sceneView.scene = scene
        self.configuration.planeDetection = .horizontal
        self.configuration.frameSemantics = .personSegmentationWithDepth//okuru-jonn
        self.sceneView.debugOptions = [SCNDebugOptions.showWorldOrigin]
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.session.run(configuration)
    }
    //ボタンのセットを行う関数
    func setUpButton() {
        self.backButtin.layer.cornerRadius = 10
        self.forwardButton.layer.cornerRadius = 10
        self.diceCreateButton.layer.cornerRadius = 10
        self.deleteButton.layer.cornerRadius = 10
        self.rightButton.layer.cornerRadius = 10
        self.leftButton.layer.cornerRadius = 10
    }
    //nodeのセットを行う関数
    func setUpNode() {
        self.planeNode1.geometry = plane1
        self.planeNode2.geometry = plane2
        self.planeNode3.geometry = plane3
        self.planeNode4.geometry = plane4
        self.planeNode5.geometry = plane5
        self.planeNode6.geometry = plane6
        
        self.planeNode1.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect1")
        self.planeNode2.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect2")
        self.planeNode3.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect3")
        self.planeNode4.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect4")
        self.planeNode5.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect5")
        self.planeNode6.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect6")
    }
    
    
    func createBox(hitTestResult: ARHitTestResult){
        
        let transform = hitTestResult.worldTransform
        let thirdColumn = transform.columns.3
        let planeDice = scene.planeDice
        
        if let camera = self.sceneView.pointOfView {
            angle = Double(camera.eulerAngles.y)
            
            //planeDice.eulerAngles = SCNVector3(0,camera.eulerAngles.y,0)
            planeDice.eulerAngles = SCNVector3(0,angle,0)
        }
        
        planeDice.geometry?.firstMaterial?.lightingModel = .constant
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
        self.sceneView.scene.rootNode.enumerateChildNodes{ ( node,stop )in
        node.removeFromParentNode()
        }
        self.scene = TestScene(kind: kind)
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
    
    @IBAction func deleteButton(_ sender: Any) {
        self.sceneView.scene.rootNode.enumerateChildNodes{ ( node,stop )in
        node.removeFromParentNode()
        }
    }
    @IBAction func leftButton(_ sender: Any) {
//        buttonInvalid()
//
//        scene.emptyNode.position = SCNVector3(scene.planeDice.worldPosition.x+Float(cos((angle+180).degreeToRadians))*0.025,scene.planeDice.worldPosition.y-0.025,scene.planeDice.worldPosition.z+Float(-sin((angle+180).degreeToRadians))*0.025)
//
//        scene.emptyNode.eulerAngles = SCNVector3(0,(angle+180).degreeToRadians,0)
//
//        scene.emptyNode.addChildNode(scene.planeDice)
//        scene.planeDice.worldPosition = SCNVector3(x,y,z)
//        scene.planeDice.eulerAngles = SCNVector3(0,0,0)
//
//        let rotateAnimation = SCNAction.rotate(by: -CGFloat(Float.pi/2), around: SCNVector3(sin((angle+180).degreeToRadians),0,cos((angle+180).degreeToRadians)), duration: duration)
//        scene.emptyNode.runAction(rotateAnimation)
//        x += 2*cos((angle+180).degreeToRadians)*0.025
//        z += -2*sin((angle+180).degreeToRadians)*0.025
        buttonInvalid()
        
        scene.emptyNode.position = SCNVector3(scene.planeDice.worldPosition.x+Float(cos(angle+Double.pi))*0.025,scene.planeDice.worldPosition.y-0.025,scene.planeDice.worldPosition.z+Float(-sin(angle+Double.pi))*0.025)
        
        scene.emptyNode.eulerAngles = SCNVector3(0,(angle+Double.pi),0)
        
        scene.emptyNode.addChildNode(scene.planeDice)
        scene.planeDice.worldPosition = SCNVector3(x,y,z)
        scene.planeDice.eulerAngles = SCNVector3(0,0,0)
        
        let rotateAnimation = SCNAction.rotate(by: -CGFloat(Float.pi/2), around: SCNVector3(sin(angle+Double.pi),0,cos(angle+Double.pi)), duration: duration)
        scene.emptyNode.runAction(rotateAnimation)
        x += 2*cos(angle+Double.pi)*0.025
        z += -2*sin(angle+Double.pi)*0.025
    }
    
    @IBAction func rightButton(_ sender: Any) {
//        buttonInvalid()
//
//               scene.emptyNode.position = SCNVector3(scene.planeDice.worldPosition.x+Float(cos((angle).degreeToRadians))*0.025,scene.planeDice.worldPosition.y-0.025,scene.planeDice.worldPosition.z+Float(-sin((angle).degreeToRadians))*0.025)
//
//               scene.emptyNode.eulerAngles = SCNVector3(0,angle.degreeToRadians,0)
//
//               scene.emptyNode.addChildNode(scene.planeDice)
//               scene.planeDice.worldPosition = SCNVector3(x,y,z)
//               scene.planeDice.eulerAngles = SCNVector3(0,0,0)
//
//               let rotateAnimation = SCNAction.rotate(by: -CGFloat(Float.pi/2), around: SCNVector3(sin(angle.degreeToRadians),0,cos(angle.degreeToRadians)), duration: duration)
//               scene.emptyNode.runAction(rotateAnimation)
//               x += 2*cos(angle.degreeToRadians)*0.025
//               z += -2*sin(angle.degreeToRadians)*0.025
        buttonInvalid()
        
        scene.emptyNode.position = SCNVector3(scene.planeDice.worldPosition.x+Float(cos(angle)*0.025),scene.planeDice.worldPosition.y-0.025,scene.planeDice.worldPosition.z+Float(-sin(angle))*0.025)
        
        scene.emptyNode.eulerAngles = SCNVector3(0,angle,0)
        
        scene.emptyNode.addChildNode(scene.planeDice)
        scene.planeDice.worldPosition = SCNVector3(x,y,z)
        scene.planeDice.eulerAngles = SCNVector3(0,0,0)
        
        let rotateAnimation = SCNAction.rotate(by: -CGFloat(Float.pi/2), around: SCNVector3(sin(angle),0,cos(angle)), duration: duration)
        scene.emptyNode.runAction(rotateAnimation)
        x += 2*cos(angle)*0.025
        z += -2*sin(angle)*0.025
    }
    
    
    @IBAction func forwardButton(_ sender: Any) {
        buttonInvalid()
               
               scene.emptyNode.position = SCNVector3(scene.planeDice.worldPosition.x+Float(cos(angle+(Double.pi/2)*3))*0.025,scene.planeDice.worldPosition.y-0.025,scene.planeDice.worldPosition.z+Float(-sin(angle+(Double.pi/2)*3))*0.025)
               
               scene.emptyNode.eulerAngles = SCNVector3(0,angle+(Double.pi/2)*3,0)
               
               scene.emptyNode.addChildNode(scene.planeDice)
               scene.planeDice.worldPosition = SCNVector3(x,y,z)
               scene.planeDice.eulerAngles = SCNVector3(0,0,0)
               
               let rotateAnimation = SCNAction.rotate(by: -CGFloat(Float.pi/2), around: SCNVector3(sin(angle+(Double.pi/2)*3),0,cos(angle+(Double.pi/2)*3)), duration: duration)
               scene.emptyNode.runAction(rotateAnimation)
               x += 2*cos(angle+(Double.pi/2)*3)*0.025
               z += -2*sin(angle+(Double.pi/2)*3)*0.025
    }
    @IBAction func backButton(_ sender: Any) {
        buttonInvalid()
        
        scene.emptyNode.position = SCNVector3(scene.planeDice.worldPosition.x+Float(cos(angle+(Double.pi/2)*1))*0.025,scene.planeDice.worldPosition.y-0.025,scene.planeDice.worldPosition.z+Float(-sin(angle+(Double.pi/2)*1))*0.025)
        
        scene.emptyNode.eulerAngles = SCNVector3(0,angle+(Double.pi/2)*3,0)
        
        scene.emptyNode.addChildNode(scene.planeDice)
        scene.planeDice.worldPosition = SCNVector3(x,y,z)
        scene.planeDice.eulerAngles = SCNVector3(0,0,0)
        
        let rotateAnimation = SCNAction.rotate(by: -CGFloat(Float.pi/2), around: SCNVector3(sin(angle+(Double.pi/2)*1),0,cos(angle+(Double.pi/2)*1)), duration: duration)
        scene.emptyNode.runAction(rotateAnimation)
        x += 2*cos(angle+(Double.pi/2)*1)*0.025
        z += -2*sin(angle+(Double.pi/2)*1)*0.025
        
       
    }
    
    @IBAction func durationSlider(_ sender: UISlider) {
        duration = Double(sender.value)
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
    
    func buttonInvalid() {
        self.rightButton.isEnabled = false
        self.leftButton.isEnabled = false
        self.forwardButton.isEnabled = false
        self.backButtin.isEnabled = false
        
        self.rightButton.tintColor = UIColor.white
        self.leftButton.tintColor = UIColor.white
        self.forwardButton.tintColor = UIColor.white
        self.backButtin.tintColor = UIColor.white
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.rightButton.isEnabled = true
            self.leftButton.isEnabled = true
            self.forwardButton.isEnabled = true
            self.backButtin.isEnabled = true
            
            self.rightButton.tintColor = UIColor.black
            self.leftButton.tintColor = UIColor.black
            self.forwardButton.tintColor = UIColor.black
            self.backButtin.tintColor = UIColor.black
        }
    }
    //方向のSCNPlaneを配置する関数
    func bottomPlaneJudge(direction: String) {
        y += 0.00000001
           let planeArr = [scene.plane1,scene.plane2,scene.plane3,scene.plane4,scene.plane5,scene.plane6]
           let minplane = minYposition(nodeArr: planeArr)
           switch minplane {
           case scene.plane1:
               let a = SCNNode()
               let b = SCNPlane(width: 0.05, height: 0.05)
               
               a.eulerAngles = SCNVector3(0,45,0)//テスト底面のノードを回転
               
               a.geometry = b
               a.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect1")
               switch direction {
               case "right":
                a.position = SCNVector3(x-0.05,y-0.025,z)
               case "left":
            a.position = SCNVector3(x+0.05,y-0.025,z)
               case "forward":
                a.position = SCNVector3(x,y-0.025,z-0.05)
               default:
                a.position = SCNVector3(x,y-0.025,z+0.05)
               }
               a.eulerAngles = SCNVector3(-90.degreeToRadians,0,0)
               scene.rootNode.addChildNode(a)
               
           case scene.plane2:
           let a = SCNNode()
           let b = SCNPlane(width: 0.05, height: 0.05)
           a.geometry = b
           a.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect2")
           switch direction {
              case "right":
               a.position = SCNVector3(x-0.05,y-0.025,z)
              case "left":
           a.position = SCNVector3(x+0.05,y-0.025,z)
              case "forward":
               a.position = SCNVector3(x,y-0.025,z-0.05)
              default:
               a.position = SCNVector3(x,y-0.025,z+0.05)
              }
           a.eulerAngles = SCNVector3(-90.degreeToRadians,0,0)
           scene.rootNode.addChildNode(a)
               
           case scene.plane3:
               let a = SCNNode()
               let b = SCNPlane(width: 0.05, height: 0.05)
               a.geometry = b
               a.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect3")
               switch direction {
                  case "right":
                   a.position = SCNVector3(x-0.05,y-0.025,z)
                  case "left":
               a.position = SCNVector3(x+0.05,y-0.025,z)
                  case "forward":
                   a.position = SCNVector3(x,y-0.025,z-0.05)
                  default:
                   a.position = SCNVector3(x,y-0.025,z+0.05)
                  }
               a.eulerAngles = SCNVector3(-90.degreeToRadians,0,0)
               scene.rootNode.addChildNode(a)
               
           case scene.plane4:
           let a = SCNNode()
           let b = SCNPlane(width: 0.05, height: 0.05)
           a.geometry = b
           a.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect4")
           switch direction {
              case "right":
               a.position = SCNVector3(x-0.05,y-0.025,z)
              case "left":
           a.position = SCNVector3(x+0.05,y-0.025,z)
              case "forward":
               a.position = SCNVector3(x,y-0.025,z-0.05)
              default:
               a.position = SCNVector3(x,y-0.025,z+0.05)
              }
           a.eulerAngles = SCNVector3(-90.degreeToRadians,0,0)
           scene.rootNode.addChildNode(a)
               
           case scene.plane5:
           let a = SCNNode()
           let b = SCNPlane(width: 0.05, height: 0.05)
           a.geometry = b
           a.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect5")
           switch direction {
              case "right":
               a.position = SCNVector3(x-0.05,y-0.025,z)
              case "left":
           a.position = SCNVector3(x+0.05,y-0.025,z)
              case "forward":
               a.position = SCNVector3(x,y-0.025,z-0.05)
              default:
               a.position = SCNVector3(x,y-0.025,z+0.05)
              }
           a.eulerAngles = SCNVector3(-90.degreeToRadians,0,0)
           scene.rootNode.addChildNode(a)
           
           default:
               let a = SCNNode()
               let b = SCNPlane(width: 0.05, height: 0.05)
               a.geometry = b
               a.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "rect6")
               switch direction {
                  case "right":
                   a.position = SCNVector3(x-0.05,y-0.025,z)
                  case "left":
               a.position = SCNVector3(x+0.05,y-0.025,z)
                  case "forward":
                   a.position = SCNVector3(x,y-0.025,z-0.05)
                  default:
                   a.position = SCNVector3(x,y-0.025,z+0.05)
                  }
               a.eulerAngles = SCNVector3(-90.degreeToRadians,0,0)
               scene.rootNode.addChildNode(a)
               print("minPlaneは\(minplane)")
               print("scene.plane1は\(scene.plane1)")
           }
       }
    //SCNNode座標の配列から最もz座標の小さいSCNNodeを返す関数
    func minYposition(nodeArr :[SCNNode]) -> SCNNode {
        var min: Float = 100.0
        var index = 0
        for i in 0 ..< nodeArr.count {
            if min > nodeArr[i].worldPosition.y {
                index = i
                min = nodeArr[i].worldPosition.y
            }
        }
        return nodeArr[index]
    }
    
    func yRotation(standardVector: [Double],angle: Double) -> SCNVector3 {
        let matrix = [[cos(angle),0,-sin(angle)],[0,1,0],[sin(angle),0,cos(angle)]]
        var ansVector = [Double](repeating: 0, count: 3)
        for i in 0 ..< 3 {
            for j in 0 ..< 3 {
                ansVector[i] += standardVector[i] * matrix[j][i]
            }
        }
        return SCNVector3(ansVector[0],ansVector[1],ansVector[2])
    }
    
}



extension Int {
    var degreeToRadians: Double { return Double(self) * .pi/180 }
}

extension Double {
    var degreeToRadians: Double { return Double(self) * .pi/180 }
}

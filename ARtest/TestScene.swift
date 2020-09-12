//
//  MakeNode.swift
//  ARtest
//
//  Created by 大塚周 on 2020/09/11.
//  Copyright © 2020 大塚周. All rights reserved.
//

import Foundation
import SceneKit

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
    
}

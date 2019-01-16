//
//  SCNVector3+Helpers.swift
//  ARExperiment
//
//  Created by Enrique Bermúdez on 1/16/19.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import SceneKit

extension SCNVector3 {
    
    func vectorScaled(to scale:Float) -> SCNVector3{
        return SCNVector3(self.x * scale , self.y * scale, self.z * scale)
    }
    
    func vectorScaled(_ x:Float = 1.0, y:Float = 1.0, z:Float = 1.0) -> SCNVector3{
        return SCNVector3(self.x * x , self.y * y, self.z * z)
    }
}


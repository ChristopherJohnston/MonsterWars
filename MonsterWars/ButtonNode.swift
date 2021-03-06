/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import SpriteKit

class ButtonNode : SKSpriteNode {

  let onButtonPress: () -> ()
  
  init(iconName: String, text: String, onButtonPress: @escaping () -> ()) {
   
    self.onButtonPress = onButtonPress
   
    let texture = SKTexture(imageNamed: "button")
    super.init(texture: texture, color: SKColor.white, size: texture.size())
    
    let icon = SKSpriteNode(imageNamed: iconName)
    icon.position = CGPoint(x: -size.width * 0.25, y: 0)
    icon.zPosition = 1
    self.addChild(icon)
    
    let label = SKLabelNode(fontNamed: "Courier-Bold")
    label.fontSize = 50
    label.fontColor = SKColor.black
    label.position = CGPoint(x: size.width * 0.25, y: 0)
    label.zPosition = 1
    label.verticalAlignmentMode = .center
    label.text = text
    self.addChild(label)
    
    isUserInteractionEnabled = true

  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    onButtonPress()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

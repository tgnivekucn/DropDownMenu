//
//  ViewController.swift
//  DropDownMenu
//
//  Created by SomnicsAndrew on 2023/10/4.
//

import UIKit

class ViewController: UIViewController {
    var dropDownView = DropDownView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        dropDownView = DropDownView(frame: CGRect(x: 50, y: 100, width: CGFloat(200), height: CGFloat(50)))
        self.view.addSubview(dropDownView)
        
        dropDownView.didSelectItem = { row in
            print("test11 dropDownView - didSelectItem, row: \(row)")
        }
    }


}


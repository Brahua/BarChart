//
//  ViewController.swift
//  BarChart
//
//  Created by MacSpace on 2/26/20.
//  Copyright © 2020 Brahua. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var chartView: MacawChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.contentMode = .scaleAspectFit
    }

    @IBAction func showBarChart(_ sender: UIButton) {
        MacawChartView.playAnimations()
    }
    
}


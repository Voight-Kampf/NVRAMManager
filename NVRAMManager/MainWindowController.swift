//
//  MainWindowController.swift
//  NVRAMManager
//
//  Created by 牛秀元 on 2017/1/23.
//  Copyright © 2017年 牛秀元. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController,  NSTableViewDataSource{
    
    
    @IBOutlet weak var tableView: NSTableView!

    let vars: Array<(String, String)> = NVRAMController().getAllVariables()
    
    override var windowNibName: String? {
        return "MainWindowController"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        tableView.dataSource = self
        //tableView.delegate = self
        //tableView.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return vars.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        let myvar = vars[row]
        
        print(myvar)
        if tableColumn == tableView.tableColumns[0] {
            return myvar.0
        }
        else {
            return myvar.1
        }
    }

}


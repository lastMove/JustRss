//
//  SecondViewController.swift
//  JustRss
//
//  Created by jason akakpo on 16/12/2014.
//  Copyright (c) 2014 More Than That. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    var datas = Array<Array<[String:String]>>();
    var titles = ["title1", "title2"];

    override func viewDidLoad() {
        super.viewDidLoad();
        var item = RSSItem();
        item.title = "article1";
        //datas.append(name:"titre1", items:[RSSItem()]);
       // datas.append([["title":"toto2"], ["title":"toto3"]]);
       // datas.append([["title":"toto2"], ["title":"toto3"]]);
        
        self.tableView .registerClass(ORGContainerCell.self, forCellReuseIdentifier: "ORGContainerCell");
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSelectItemFromCollectionView:", name: "didSelectItemFromCollectionView", object: nil);
        DataManager.sharedInstance.buildDatas(buildData);
    }
    
    func buildData(name:String, feeds:[RSSItem])
    {
        self.titles.append(name);
        var allFeeds = Array<[String : String]>();
        for feed in feeds
        {
            allFeeds.append(["title":feed.title]);
        }
        self.datas.append(allFeeds);
        self.tableView.reloadData()
    }
    
    func didSelectItemFromCollectionView(not:NSNotification)
    {
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.datas.count;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:ORGContainerCell = tableView.dequeueReusableCellWithIdentifier("ORGContainerCell", forIndexPath: indexPath) as ORGContainerCell;
        var cellData = self.datas[indexPath.section];
    
        //let articleData = [[["title":cellData.items[0].title]]];
        
        cell.setCollectionData(cellData);
        return cell;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180.0;
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titles[section];
    }
    

}


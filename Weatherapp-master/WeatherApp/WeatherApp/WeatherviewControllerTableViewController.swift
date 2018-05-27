//
//  WeatherviewControllerTableViewController.swift
//  WeatherApp
//
//  Created by SOURAV MAJUMDAR on 5/5/18.
//  Copyright © 2018 SOURAV MAJUMDAR. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherviewControllerTableViewController: UITableViewController, UISearchBarDelegate{

    
    // outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    //variables
    var forecastData = [Weather]()
    
    //functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        
        
        updateWeatherForLocation(location: "Melbourne")
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            updateWeatherForLocation(location: locationString)
        }
        
    }
    
    func updateWeatherForLocation (location:String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
            if let location = placemarks?.first?.location {
             Weather.weatherforecast(withLocation: location.coordinate, completion: { (results:[Weather]?) in
                        
                        if let weatherData = results {
                        self.forecastData = weatherData
                            
                            DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        }
                })
            }
        }
        }
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return forecastData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM, yyyy"
        
        return dateFormatter.string(from: date!)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Mycell", for: indexPath)
        
        let weatherObject = forecastData[indexPath.section]
        
        cell.textLabel?.text = weatherObject.summary
       
        cell.textLabel!.lineBreakMode = .byWordWrapping
        cell.textLabel!.font = UIFont.systemFont(ofSize: 16.0)
        cell.detailTextLabel?.text = "Tempreture : \(Int(weatherObject.temperature)) °F" + " " + " Humidity : \(Double((weatherObject.humidity) * 100)) % " + " " + "Pressure : \(Double(weatherObject.pressure)) Pa"
        cell.detailTextLabel!.font = UIFont.systemFont(ofSize: 10.0)
        cell.imageView?.image = UIImage(named: weatherObject.icon)
        
        return cell
    }

}

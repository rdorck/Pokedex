//
//  Pokemon.swift
//  Pokedex
//
//  Created by Robert Rock on 12/22/15.
//  Copyright © 2015 Robert Rock. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    //==========================================================================================================
    // MARK: Properties
    //==========================================================================================================
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _nextEvolutionText: String!
    private var _pokemonUrl: String!
    
    //==========================================================================================================
    // MARK: Getters & Setters
    //==========================================================================================================

    /*
     * name & pokedexId are in init()
     */
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    
    
    
    //==========================================================================================================
    // MARK: Initialization
    //==========================================================================================================
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
        
    }
    
    //==========================================================================================================
    // MARK: API Interaction
    //==========================================================================================================
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        /* Cast our custom String URL to type NSURL */
        let url = NSURL(string: _pokemonUrl)!
        
        /*
         * Perform GET request & JSON is returned in (response.result)
         */
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            //print(result.value.debugDescription)
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                print("weight = \(self._weight)")
                print("height = \(self._height)")
                print("attack = \(self._attack)")
                print("defense = \(self._defense)")
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    print(types.debugDescription)
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    
                    if types.count > 1 {
                        for var i=1; i < types.count; i++ {
                            if let name = types[i]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                print("type = \(self._type)")
                
                /* 
                 * Second download & GET request to get pokemon description from api b/c desciption was another API url
                 */
                if let descArray = dict["descriptions"] as? [Dictionary<String, String>] where descArray.count > 0 {
                    if let url = descArray[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            let desResult = response.result
                            if let descDict = desResult.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print("description = \(self._description)")
                                }
                            }
                            completed()
                        }
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    if let to = evolutions[0]["to"] as? String {
                        
                        /* It is not a mega evolution (ie. mega is no-where in name) */
                        if to.rangeOfString("mega") == nil {
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                /*
                                 * "resource_uri" : "/api/v1/pokemon/420/"   We only want the # (pokedexId) so,
                                 *      I replace the /api/v1/pokemon/ with a blank string, leaving only "420/"
                                 *    Then remove trailing "/" w/ same method, leaving only the pokedexId
                                 */
                                let newString = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newString.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionText = to

                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLevel = "\(lvl)"
                                }
                                print("nextEvolutionId = \(self._nextEvolutionId)")
                                print("nextEvolutionLevel = \(self._nextEvolutionLevel)")
                                print("nextEvolutionText = \(self._nextEvolutionText)")
                            }
                        }
                    }
                }
            }
            
        }
        
    }
    
    
    //==========================================================================================================
    // MARK:
    //==========================================================================================================

    
    
    
    
    
}
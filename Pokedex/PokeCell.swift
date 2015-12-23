//
//  PokeCell.swift
//  Pokedex
//
//  Created by Robert Rock on 12/23/15.
//  Copyright © 2015 Robert Rock. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        nameLabel.text = self.pokemon.name.capitalizedString
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
    
}

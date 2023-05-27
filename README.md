# Godot-Pivot-Helper
A Godot 3.3 plugin that creates pivot points on a 2D sprite.

## What this plugin includes
1. Pivot Node(Node2D): This node takes a PivotResource and a AnimatedSprite and processes the data from the PivotResource object.
2. PivotResource(Resource): This resource contains a dictionary in the format {"Animation Name": [PivotPointResource]}
3. PivotPointResource(Resource): This resource contains all of the properties that are applied to the Pivot node.

## How to install
1. In Godot create the directory addons/pivot-helper
2. Add the files from this repository to addons/pivot-helper
3. Go to Project > Project Settings... > Plugins and enable "Pivot Helper"

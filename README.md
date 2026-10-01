# ParsleStory

An attempt at parsing MapleStory maps in Godot 4.7.1 by hand! Inspired by https://github.com/mikuYongh/Godot-mapleStory

Currently only tested with GMS v83.

## What's implemented thus far

As in folders:

- [x] Map (full render!)
- [x] Back
- [x] Tile
- [x] Obj
- [ ] WorldMap (if ever)

As in everything else (if I ever get to that):

- [x] Footholds
- [ ] Ropes
- [ ] NPCs
- [ ] Mobs
- [ ] Portals

## Alright now how do I obtain the files to use this

- Install MapleStory from somewhere on the internet!
- Using **HaRepacker**, extract Map.wz to a folder named *mapleExport* next to your Godot install. Be sure to choose JSON as the export format!

You should end up with a folder named *Map.wz* inside *mapleExport*.
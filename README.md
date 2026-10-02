# ParsleStory

An attempt at parsing MapleStory maps in Godot 4.7.1 by hand! This project is designed to be able to be inserted in any project with as little changes as possible.

Inspired by https://github.com/mikuYongh/Godot-mapleStory , currently only tested with GMS v83.

## What's implemented thus far

As in folders:

- [x] Map (full render!)
- [x] Back
- [x] Tile
- [x] Obj
- [ ] WorldMap (if ever)

As in everything else (if I ever get to that):

- [x] Background music
- [x] Footholds
- [ ] Ropes
- [ ] NPCs
- [ ] Mobs
- [x] Portals (barely)

## Alright now how do I obtain the files to use this

- Install MapleStory from somewhere on the internet!
- Using **HaRepacker**, extract Map.wz to a folder named *mapleExport* next to your Godot install. Be sure to choose JSON as the export format!
- Also extract Sound.wz, but this time choose to export as MP3.

You should end up with two folders named *Map.wz* and *Sound.wz* inside *mapleExport*.
///////////////////////////
//HOW TO USE THIS TILESET//
///////////////////////////

Hello, fellow game developer! Thank you for downloading the Medieval Village and Haunted Village tilesets. Here are a few pointers to help you navigate and make sense of this zip file.

Tips:

- There are two styles to choose from: Medieval Village, and Haunted Village.

- You can find all the pieces to put together your levels in the "pieces" folders.

- Many of the pieces are set up to align to a 16x16 grid. Remember this when you're putting it together!

- You can make buildings as large or as small as you want. The roof can be a bit of a puzzle to put together, but you can see some examples in the wallpaper image to get you started.

- For almost every building piece, there are multiple variants showing different states of damage. There are also debris particles included that you can have fly out when the buildings are hit.

- Barrels should use the barrel shadow if they're placed in front of a building.

- Some terrain files have the "_full" suffix, and some do not. If you want your player to be in between two grass layers, you can use the ones without "_full" in conjunction with the terrain_bg1_* images. Otherwise, use the ones with "_full" and don't worry about it.

- Due to the nature of the terrain/grass pattern, there are a lot of terrain files. I could go in detail trying to explain specific rules as to how to put the terrain together, but here's my best advice: Just start placing terrain with "1" in the filename, and if the rock pattern doesn't match up after placing a slope, switch to "2". (And then switch as needed.) You'll figure it out.

- You can help make sense of the labels using the following guide, which applies to all my tilesets.

File name definitions:
	- "terrain"			Part of the tileset's terrain. The player probably stands on this.
	- "left/right/top/bottom"	The left/right/top/bottom wall or edge of the terrain.
	- "center"			Context-specific. Usually means the middle of something.
	- "bg1", "bg2", etc.		Background. Higher number indicates further back.
	- "fg1", "fg2", etc.		Foreground. Higher number indicates further forwards.
	- "_1", "_2", "_3", etc.	A suffix with a number indicates there are multiple variants of this object.
	- "_f1", "_f2", "_f3", etc.	Suffixes with "f" and a number indicate a frame of an animation.
	- "2x2", "4x4", etc.		Indicates the size of this object, in tiles.
	- "A1", "B1", etc.		"A," "B," "C," and so on indicate different patterns, styles, or objects.
					The number following the letter indicates a variant.
Medieval Village specific:
	- "building"			Part of a building.
	- "panel"			A piece of the front of a building.
	- "roof"			A piece of the roof of a building.
	- "roof_top"			The tippy-top of the building.
	- "panel" + "roof" + direction	Indicates that this panel is bounded on one or both sides by roof pieces.
	- "damage_med"			Indicates medium damage state.
	- "damage_high"			Indicates high damage state.
	- "_side"			Indicates the left side of a building (the "3D" depth).
	- "subroof"			The smaller roof things that come out of the roof. Dunno the technical term.

- Don't know how to put something together? Take a look at the example/wallpaper image and it might be able to help you.

- Really curious how it was all made? Need some hints for layer ordering? Check out medieval_village.psd. It's got it all.

Got questions? Hit me up at:
@untiedgames (twitter)
contact@untiedgames.com (email)

Phew, I think that should cover everything.
Thanks again!
-Will

/////////
//BONUS//
/////////

Want to make the buildings come down entirely? Here's what I'd do if I was making a game like that.
First, I'd detect whether or not a building has sustained enough damage to collapse. (Your call on how to do this!)
If it has, I'd apply a shake effect to the whole thing, and slowly lower the building down.
All building layers are behind the terrain layers, so the building will sink behind the terrain.
As it's coming down, from the base of the building I'd spawn debris particles flying upwards.
When the building has sunken entirely underneath the terrain, I'd remove the building object from the game.

Good luck, and have fun! :)
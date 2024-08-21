Levels are described by initial positions of the frogs.
## Default map layout
The default map layout looks like this:
[
	[x, x, x],
	[  x, x],
	[x, x, x],
	[ x, x],
	[x, x, x]
]
It is composed of: 
- 3 times rows with 3 lilypads (indexes: 0, 2, 4)
- 2 times rows with 2 lilypads (indexes: 1, 3)
	
## Frog/lilypad values
Are defined in `level_enum.gd`.
0 - empty lilypad
1 - green frog (have to be jumped over to solve level)
2 - red frog (has to remain at the end)

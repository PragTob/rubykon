## 0.2 (2015-10-03)
Rewrote data representation to be smaller and do way less allocations.

### Performance
* board is now a one dimensional array with each element corresponding to one cutting point (e.g. 1-1 is 0, 3-1 is 2, 1-2 is 19 (on 19x19).
* no more stone class, the board just stores the color of the stone there. Instead of `Stone` objects, an identifier (see above) and its color are passed around.
* what would be a ko move is now stored on the game, making checking faster and easier
* dupping games is easier thanks to simpler data structures

### Bugfixes
* captures are correctly included when scoring a game

## 0.1 (2015-09-25)
Basic game version, able to perform random playouts and benchmark those.
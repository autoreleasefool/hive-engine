## 2.4.2

* Fix a bug where moves were not possible in a newly cloned state -- a stored property that the queen had been played was not being copied

## 2.4.1

* Return `Bool` result when `GameState.apply(relativeMovement:)` or `GameState.apply(move:)` is invoked

## 2.4.0

* Added properties to generate [Universal Hive Protocol](https://github.com/jonthysell/Mzinga/wiki/UniversalHiveProtocol) strings (GameString, GameStateString, GameTypeString, TurnString, MoveStrings)
* Added `isExpansion` property to `GameState.Option`
* `GameState.set(option:to:)` to update modifiable options in a game before the game begins

## 2.3.0

* Renamed `GameState.Options` to `GameState.Option` and deprecated `GameState.Options`
* Remove spaces from GameState.Option raw values

## 2.2.0

* Make notation initializers public
* Add method to convert `RelativeMovement` to a `Movement`

## 2.1.0

* Swift 5.1+
* [Universal Hive Protocol](https://github.com/jonthysell/Mzinga/wiki/UniversalHiveProtocol) compliance
* Unit notation for unique insects (queen, ladyBug) is now correctly produced without index

## 2.0.0

* Added a new `.pass` Movement for players who become shut out and unable to make any other moves
* `lastMovedUnit` and `lastMovedPlayer` added as convenience accessors
* `availableMoves` is cached after its first calculation, for improved performance. It is cleared when a move is applied or undone
* 3 new `GameState.Options`:
    * `restrictedOpening`: limits `Black`'s first move to a single position, to reduce branching
    * `noFirstMoveQueen`: optional rule, prevents either play from playing their Queen as their first piece
    * `allowSpecialAbilityAfterYoink`: enable using the Pill Bug's ability immediately after the ability has been used on it.
* Passing [perft tests](https://github.com/jonthysell/Mzinga/wiki/Perft)

### Breaking changes
* Removed `requireMovementValidation` accessor, replaced by `GameState.Options.disableMovementValidation`
* Renamed `moves(as:in:)` to `canCopyMoves(of:in)` to reduce ambiguity with method bearing a similar name
* Removed `opponentMoves` due to the additional complexity required to maintain its functionality
* A shut out player is no longer skipped. Instead, they have only 1 available move, `.pass`, and must play it

## 1.2.0

* Add support for [standard Hive notation](http://www.boardspace.net/english/about_hive_notation.html)
* Limit the pieces playable from hand to be only the unit of each class with the lowest index. For example, with 3 ants with indices 1, 2, and 3, only the ant with index 1 can be placed. After it is placed, only the ant with index 2 can be placed, etc.

## 1.1.0

* Human readable encodings for Movements for ease of debugging.

## 1.0.0

* With the release and support of Swift 5.0, the engine now appears stable.
* The Hive Engine version 1.0 is capable of tracking the state of a game of Hive with the 3 official expansions included.

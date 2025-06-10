# Solitaire - Project 2 CMPM 121

- **GitHub Repo**: https://github.com/varunpalanisamy/Project_2  
- **Download .love**: [Solitaire.love](sandbox:/mnt/data/Solitaire.love)  

## Programming Patterns Used
- **Class/Object Pattern**: Emulated classes in Lua using metatables for Card, Deck, Pile, and Game, providing clear separation of responsibilities.
- **Factory Pattern**: Deck:new() constructs a full 52-card deck programmatically, centralizing card creation.
- **Singleton Pattern**: The Game module serves as a single global game controller, managing state and game loop.
- **Type Object Pattern**: Pile behavior (stock, waste, tableau, foundation) varies by a type field rather than subclassing, simplifying pile logic.
- **Event-Driven Pattern**: Used Love2D callbacks (love.load, love.update, love.draw, love.mousepressed, love.mousereleased) to drive game interactions.
- **State Pattern**: We added a simple “win” flag to manage the game-over UI versus normal play.  
- **Strategy Pattern**: Shuffling uses Lua’s math.randomseed + math.random calls, allowing us to swap in other shuffle strategies if desired.

## Feedback from Discussion Sections

1. **Koushik Vasa**  
   - **Feedback**: “Every time I run `love .`, I see the same deck order.”  
   - **Adjustment**: Seeded Lua’s RNG with math.randomseed(os.time()) before shuffling to guarantee a fresh deal each run.  
2. **Prasanth Dendekuri**  
   - **Feedback**: “A reset button would be nice since you get stuck alot.”  
   - **Adjustment**: Moved the reset-click handler outside the “win” check so it’s always active, and drew the reset icon unconditionally.  
3. **Ramneek Singh**  
   - **Feedback**: "Add a win screen so i know when you win”  
   - **Adjustment**: Added a win.png to play when user won. Wrapped love.graphics.newImage in pcall, provided a text fallback, and corrected the filename to match win.png.  

## Postmortem

**Pain Points**  
- **Shuffle determinism**: Initially saw the same deal every launch.  
- **Reset logic**: Button only appeared on win and was non-responsive otherwise.  
- **Image loading**: Filename mismatch & unsupported format crash.  
- **Code duplication**: Some click-test logic was repeated.

**Refactoring Plan & Success**  
- Seeded the proper RNG → **confirmed** totally different deals each run.  
- Unified and relocated reset handler → **reset** works at any time.  
- Added `pcall` + corrected filenames → no more image load errors.  
- Consolidated click logic into single method → easier to maintain and extend.

## Assets

- **Card Sprites**  
  – 2–10 of ♣♦♥♠ PNGs, J/Q/K/A variations, sourced from PNG-cards-1.3: https://opengameart.org/content/playing-cards-vector-png  
- **Card Back** (`facedown.png`): https://www.udioutlet.shop/?path=page/ggitem&ggpid=3095198  
- **Reset Button** (`reset.png`): https://thenounproject.com/icon/reset-button-3648091/  
- **Win Screen** (`win.png`): https://pngtree.com/freepng/you-win-celebration-tag_8783670.html  
# Solitaire - Project 1 CMPM 121

## Programming Patterns Used
- **Class/Object Pattern**: Emulated classes in Lua using metatables for Card, Deck, Pile, and Game, providing clear separation of responsibilities.
- **Factory Pattern**: Deck:new() constructs a full 52-card deck programmatically, centralizing card creation.
- **Singleton Pattern**: The Game module serves as a single global game controller, managing state and game loop.
- **Type Object Pattern**: Pile behavior (stock, waste, tableau, foundation) varies by a type field rather than subclassing, simplifying pile logic.
- **Event-Driven Pattern**: Used Love2D callbacks (love.load, love.update, love.draw, love.mousepressed, love.mousereleased) to drive game interactions.

## Postmortem
**What Went Well**  
- Modular structure with clearly separated modules/files.  
- Dynamic hitboxes and responsive drag & drop.  
- Comprehensive handling of Klondike rules (draw-3, recycle, auto-flip, foundations).

**What I’d Do Differently**  
- Introduce a State Pattern to cleanly manage game phases (e.g., dealing, playing, win/loss).  
- Add smooth card animations and sound effects for better feedback.  
- Write unit tests for pile logic and shuffling to catch edge cases early.

## Assets
- **Card Sprites**: PNG‑cards‑1.3 (https://opengameart.org/content/playing-cards-vector-png)  
- **Card Back**: facedown.png (https://www.udioutlet.shop/?path=page/ggitem&ggpid=3095198)

# Game Architecture: Top-Down ARPG

This document outlines the proposed architecture for the top-down ARPG project.

## High-Level Overview

The architecture is designed to be modular and scalable, allowing for systematic feature implementation.

```mermaid
graph TD
    subgraph Core Systems
        GameManager("Game Manager (Singleton)")
        SceneManager("Scene Manager")
        InputManager("Input Manager")
        GameState("Game State (Save/Load)")
    end

    subgraph Entity Systems
        Player("Player (CharacterBody2D)")
        Enemy("Enemy (CharacterBody2D)")
        NPC("NPC (StaticBody2D/Area2D)")
        Stats("Stats Component")
        Inventory("Inventory Component")
        Abilities("Abilities Component")
    end

    subgraph World Systems
        World("World (Node2D)")
        TileMap("TileMap")
        Interactables("Interactable Objects (Area2D)")
        Camera("Camera2D")
    end

    subgraph UI Systems
        UIManager("UI Manager (CanvasLayer)")
        HUD("HUD (Health, Mana, etc.)")
        InventoryMenu("Inventory Menu")
        DialogueBox("Dialogue Box")
        QuestLog("Quest Log")
    end

    subgraph Gameplay Logic
        CombatSystem("Combat System")
        QuestSystem("Quest System")
        LootSystem("Loot System")
    end

    GameManager --> SceneManager
    GameManager --> InputManager
    GameManager --> GameState
    GameManager --> UIManager
    GameManager --> QuestSystem

    InputManager --> Player

    Player -- has a --> Stats
    Player -- has an --> Inventory
    Player -- has --> Abilities
    Player -- interacts with --> CombatSystem

    Enemy -- has a --> Stats
    Enemy -- interacts with --> CombatSystem

    World --> TileMap
    World --> Player
    World --> Enemy
    World --> NPC
    World --> Interactables
    World -- contains --> Camera

    Player -- triggers --> Interactables
    Player -- talks to --> NPC

    CombatSystem -- affects --> Stats
    CombatSystem -- generates --> LootSystem

    Inventory -- managed by --> InventoryMenu
    QuestSystem -- displayed in --> QuestLog
    NPC -- gives quests to --> QuestSystem
    NPC -- initiates --> DialogueBox

    UIManager --> HUD
    UIManager --> InventoryMenu
    UIManager --> DialogueBox
    UIManager --> QuestLog
```

## Architecture Breakdown:

### 1. Core Systems (Singletons/Auto-loads):
*   **Game Manager:** The central hub of the game, responsible for coordinating other managers and handling global game states (e.g., pause, play).
*   **Scene Manager:** Manages loading, unloading, and transitioning between different game scenes (e.g., overworld, dungeons, menus).
*   **Input Manager:** Processes all player inputs. This will remap the existing input actions to be more suitable for a top-down game (e.g., 8-directional movement).
*   **Game State:** Handles saving and loading player progress, including stats, inventory, and quest status.

### 2. Entity Systems (Scene-based):
*   **Player:** The main player character scene. It will contain a state machine for handling different actions (idle, walking, attacking, using items).
*   **Enemies/NPCs:** Base scenes for all non-player characters. They will have their own AI and behavior logic (e.g., pathfinding, attacking, dialogue).
*   **Components:** Reusable nodes that can be attached to entities to provide functionality:
    *   `StatsComponent`: Manages health, mana, attack power, defense, etc.
    *   `InventoryComponent`: Holds items, equipment, and currency.
    *   `AbilitiesComponent`: Manages spells or special skills.

### 3. World Systems:
*   **World Scene:** The main container for a game level or area.
*   **TileMap:** Used to build the level's layout and handle basic collision. We will need to replace the isometric `TileSet` with a top-down one.
*   **Interactable Objects:** Doors, chests, switches, etc., that the player can interact with.

### 4. UI Systems:
*   **UI Manager:** A central node on a `CanvasLayer` to manage all UI elements.
*   **HUD, Menus, etc.:** Separate scenes for each UI component, which are instanced and managed by the UI Manager.

### 5. Gameplay Logic (Scripts/Nodes):
*   **Combat System:** A script or node that handles the logic of combat, including hit detection, damage calculation, and status effects.
*   **Quest System:** Manages quest objectives, progress, and rewards.
*   **Loot System:** Determines item drops from enemies or chests.
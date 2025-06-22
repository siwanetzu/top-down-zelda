# Implementation phases Zelda

## Phase 1: Core Gameplay Loop (The Foundation)
This phase is about creating a playable, repeatable slice of the game. The goal is to get the full "attack and be attacked" loop working.
* Player Character
    * [x] ✅ Basic Movement
    * [x] ✅ Attack Animation & Logic
    * [x] ✅ Directional Attack Hitbox (The player can swing and hit things)
    * [x] ✅ Player Health & Taking Damage (The player can be hurt and defeated)
* Enemy Character
    * [x] ✅ Basic Enemy Scene (CharacterBody2D)
    * [x] ✅ Basic AI (Idle state and Chasing the player when in Area2D range)
    * [x] ✅ Enemy Health & Taking Damage (The take_damage function exists)
    * [x] ✅ Enemy Attack Logic (The enemy stops in range and attacks the player)
    * [x] ✅ Death Sequence (What happens when enemy health reaches zero)
    * [x] ✅ Advanced AI for enemy (idle, movement, attack states)
* Core Interaction & UI
    * [x] ✅ Player-to-Enemy Damage System (The hitbox successfully calls the enemy's take_damage function)
    * [x] ✅ Enemy-to-Player Damage System (The enemy's attack successfully calls the player's take_damage function)
    * [x] ✅ Basic UI (Heads-Up Display) (Displaying player health, etc.)
    * [x] ✅ Loot Spawning & Interaction (Dropping items on death and picking them up)

## Phase 2: Expanding the World & Systems (Making it a "Game")
This phase will begin once the core combat loop from Phase 1 is fully functional.
* World & Environment
    * [ ] Level Design with TileMapLayer
    * [ ] Environment Collision
* Advanced AI
    * [ ] Pathfinding with NavigationServer2D
    * [ ] Varied Enemy Types (e.g., ranged enemies)
* Core RPG Systems
    * [ ] Inventory System
    * [ ] Equipment System
    * [ ] Dialogue System

## Phase 3: Adding RPG Depth & Content (The "Fun Stuff")
This is the long-term vision for the project, adding layers of engagement and content.
* Player Progression
    * [ ] Stats System (Strength, Defense, etc.)
    * [ ] Experience Points (XP) & Leveling Up
* Game Content
    * [ ] NPC Characters & Quests
    * [ ] Magic & Special Abilities System
* Polish
    * [ ] Sound Effects & Music
    * [ ] Visual Effects (VFX)
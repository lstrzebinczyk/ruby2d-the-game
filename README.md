# The Game
## Description

This is an implementation of a game based on [ruby2d](http://www.ruby2d.com/). In simplest way of explanation, I am trying to create something like [dwarf fortress](http://www.bay12games.com/dwarves/), with a couple of main game modes in mind:
  - simulation, where player/observer doesn't do anything, just witnesses how the city grows
  - city building, where player is allowed to interact with the world similarily to dwarf fortress
  - single character, where player would have full controll over one character. Something like the sims / dwarf fortress adventurer mode.

# The code

## Basic config files

### lib/index.rb

This is where everything gets set up and started

### lib/update.rb

This is main update loop. It's called (hopefully) 60 times per second, updates the mouse position and logic assiociated with it, as well as updates the world.

### lib/controls.rb

This is where all main player controls are specified, from keyboard and mouse.

## Game code concepts

### Character

This is the main actor in the game. The game is mostly about them, and their struggles to survive and build a nice, thriving city.

Each character has a type. Characters of different types will behave differentely and have different needs.

Each character has his own needs, that he will try to fulfill. Currently those include:

* eating
* sleeping

But more will come. Hopefully whole piramid of needs.

### Jobs

Jobs are a high-level concepts of something that character intends or is requested to do. Player interaction can create jobs that will then be taken by characters. Jobs are things like "cut that tree", "build that building", "carry that thing to the storage", "eat something".

Jobs that are waiting for characters to be taken are stored in `$job_list`.

Jobs can be introduced into the game by a player, or produced by structures.

Jobs have various types, and characters will prefer jobs of some types over jobs of another types, for example woodcutter will take `:woodcutting` jobs first over `:hauling` jobs, and will never take `:gathering` jobs.

Job is essentially a chain of actions, which it must produce via `#action_for(character)` method.

### Actions

Actions are a single-purpose behaviors that characters will perform in order to complete a job.

Actions can be chained together.

### Structures

Structures are, basically buildings, workshops, anything that needs to be built.

### Zones

Zones are areas designated to fit a purpose. Zones do not get build, they are just designated.

### Menu and game modes

Menu contains buttons, and each of them, when active, corresponds to a game mode. Game mode is a class, that interacts with the world in a specific way, where player wants it. Game modes are the only way player can interact with the world.

# Contributing

There is an universe of things that can be done in here, and a plenty of fun things to code. You can contribute in multiple ways:

* Discuss issues, all ideas and comments are welcome
* Suggest new features
* Make something faster. Since it's a game, all performance improvements are welcome
* Implement something new. Review issues and pick something that you'd like to do.
* Make something more realistic or fun. You can review current implementation and discuss how something can be done better.

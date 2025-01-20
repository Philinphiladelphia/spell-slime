extends Node

var crystals: int = 100

var max_health: int = 100
var health: int = 100

var max_mana: int = 100
var mana: int = 100

var spell: Spell
var attack_stats: PlayerAttackStats
var movement_stats: MovementStats

var player_location: Vector2 = Vector2(0,0)

signal initialized

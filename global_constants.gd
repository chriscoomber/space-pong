extends Node

var MAX_ACCELERATION: float = -3000.0
var GRAVITY: float = 2000.0
var MAX_SPEED: float = 750.0
var BALL_Y_GROWTH: float = 0.75
var BALL_X_GROWTH: float = 0.2
var THINKING_TIME: float = 0.15
var INACCURACY: float = 0.2

const MAX_Y: float = 240.0

var ball_wraparound: bool = true
var wraparound: bool = true
var difficulty: int = 1
var show_particles: bool = true

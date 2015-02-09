import "dart:html";
import "package:play_phaser/phaser.dart";

void main() {
    Game game1 = new Game(800, 480, CANVAS, "", new GameState());
}

class Direction {
    static final Direction UP = new Direction("UP");
    static final Direction RIGHT = new Direction("RIGHT");
    static final Direction DOWN = new Direction("DOWN");
    static final Direction LEFT = new Direction("LEFT");
    static final List<int> VALUES = [UP, RIGHT, DOWN, LEFT];

    String name;

    Direction(this.name);

    @override
    String toString() {
        return this.name;
    }
}

class Entity {
    Game game;
    Sprite sprite;
    Direction direction;
    Point position;

    Entity(this.game,
           String assetName,
           Point initialPosition,
           Direction initialDirection) {
        this.position = initialPosition;
        this.sprite = this.game.add.sprite(this.position.x,
                                          this.position.y,
                                          assetName);
        int c = 0;
        for (Direction d in Direction.VALUES) {
            this.sprite.animations.add(d.toString(),
                                       [c, c + 1, c + 2, c + 3]);
            c += 4;
        }
        this.setDirection(initialDirection);

        this.game.physics.enable(this.sprite, Physics.ARCADE);
    }

    void setDirection(Direction d) {
        if (this.direction != d) {
            this.direction = d;
            this.sprite.animations.play(d.toString(), 5, true);
        }
    }
}

class Player extends Entity {
    Player(Game game, Point initialPosition, Direction initialDirection)
        : super(game, "player", initialPosition, initialDirection);
}

class GameState extends State {
    CursorKeys cursors;
    Tilemap map;
    List<TilemapLayer> layers = [];
    Player player;
    
    void preload() {
        this.game.load.image("tiles", "assets/tilesets/rpg.png");
        this.game.load.tilemap("level1",
                               "assets/tilemaps/Map.json",
                               null,
                               Tilemap.TILED_JSON);
        this.game.load.spritesheet("player",
                                   "assets/spritesheets/lucas.png",
                                   17, 25,
                                   16,
                                   0, 4);
    }

    void create() {
        this.game.scale.pageAlignHorizontally = true;
        this.game.scale.pageAlignVertically = true;
        this.game.scale.scaleMode = ScaleManager.SHOW_ALL;
        this.game.scale.setScreenSize();

        this.game.physics.startSystem(Physics.ARCADE);

        this.map = this.game.add.tilemap("level1");
        this.map.addTilesetImage("tiles", "tiles");
        for (int i = 0; i < this.map.layers.length; i++) {
            this.layers.add(this.map.createLayer(i));
            this.layers[i].resizeWorld();
        }
        this.layers.last.alpha = 0;
        this.map.setCollisionBetween(1, 2000, true, "Blocked");

        this.player = new Player(this.game, new Point(128, 256), Direction.UP);
        this.game.camera.follow(this.player.sprite);

        this.cursors = this.game.input.keyboard.createCursorKeys();
    }

    void update() {
        this.player.sprite.body.velocity.set(0, 0);
        if (this.cursors.up.isDown) {
            this.player.sprite.body.velocity.y = -150;
            this.player.setDirection(Direction.UP);
        } else if (this.cursors.down.isDown) {
            this.player.sprite.body.velocity.y = 150;
            this.player.setDirection(Direction.DOWN);
        }
        if (this.cursors.left.isDown) {
            this.player.sprite.body.velocity.x = -150;
            this.player.setDirection(Direction.LEFT);
        } else if (this.cursors.right.isDown) {
            this.player.sprite.body.velocity.x = 150;
            this.player.setDirection(Direction.RIGHT);
        }
        this.game.physics.arcade.collide(this.player.sprite, this.layers.last);
    }
}

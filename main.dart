import "dart:html";
import "package:play_phaser/phaser.dart";

void main() {
    Game game1 = new Game(800, 480, AUTO, "", new GameState());
}

class GameState extends State {
    CursorKeys cursors;
    Tilemap map;
    List<TilemapLayer> layers = [];
    Sprite image;

    void preload() {
        this.game.load.image("tiles", "assets/tilesets/rpg.png");
        this.game.load.tilemap("level1",
                               "assets/tilemaps/Map.json",
                               null,
                               Tilemap.TILED_JSON);
        this.game.load.image("player", "assets/sprites/car.png");
    }

    void create() {
        this.scale.scaleMode = ScaleManager.SHOW_ALL;

        this.map = this.game.add.tilemap("level1");
        this.map.addTilesetImage("tiles", "tiles");
        for (int i = 0; i < this.map.layers.length; i++) {
            this.layers.add(this.map.createLayer(i));
            this.layers[i].resizeWorld();
        }
        //this.layers.last.alpha = 0.5;
        this.map.setCollisionBetween(1, 100000, true, "Blocked");
        this.image = game.add.sprite(300, 200, "player");
        this.image.scale.set(3, 3);

        this.game.physics.startSystem(Physics.ARCADE);
        this.game.physics.enable(this.image, Physics.ARCADE);
        this.game.physics.arcade.collide(this.image, this.layers.last);

        this.game.camera.follow(this.image);

        this.cursors = this.game.input.keyboard.createCursorKeys();
    }

    void update() {
        this.image.body.velocity.set(0, 0);
        if (this.cursors.up.isDown) {
            this.image.body.velocity.y = -150;
        } else if (this.cursors.down.isDown) {
            this.image.body.velocity.y = 150;
        }
        if (this.cursors.left.isDown) {
            this.image.body.velocity.x = -150;
        } else if (this.cursors.right.isDown) {
            this.image.body.velocity.x = 150;
        }
    }
}

import "dart:html";
import "package:play_phaser/phaser.dart";

void main() {
    Game game1 = new Game(800, 480, AUTO, "", new GameState());
}

class GameState extends State {
    CursorKeys cursors;
    Tilemap map;
    List<TilemapLayer> layers = [];
    Sprite player;
    Animation anim;

    void preload() {
        this.game.load.image("tiles", "assets/tilesets/rpg.png");
        this.game.load.tilemap("level1",
                               "assets/tilemaps/Map.json",
                               null,
                               Tilemap.TILED_JSON);
        this.game.load.spritesheet("player",
                                   "assets/spritesheets/lucas.png",
                                   17, 25,
                                   4, 0, 4);
    }

    void create() {
        this.game.scale.pageAlignHorizontally = true;
        this.game.scale.pageAlignVertically = true;
        this.game.scale.scaleMode = ScaleManager.SHOW_ALL;
        this.game.scale.setScreenSize();

        this.map = this.game.add.tilemap("level1");
        this.map.addTilesetImage("tiles", "tiles");
        for (int i = 0; i < this.map.layers.length; i++) {
            this.layers.add(this.map.createLayer(i));
            this.layers[i].resizeWorld();
        }
        this.layers.last.alpha = 0;
        this.map.setCollisionBetween(1, 2000, true, "Blocked");

        this.player = game.add.sprite(128, 256, "player");
        this.player.scale.set(4, 4);
        this.anim = this.player.animations.add("walk");
        this.anim.play(5, true);

        this.game.physics.startSystem(Physics.ARCADE);
        this.game.physics.enable(this.player, Physics.ARCADE);

        this.game.camera.follow(this.player);

        this.cursors = this.game.input.keyboard.createCursorKeys();
    }

    void update() {
        this.player.body.velocity.set(0, 0);
        if (this.cursors.up.isDown) {
            this.player.body.velocity.y = -150;
        } else if (this.cursors.down.isDown) {
            this.player.body.velocity.y = 150;
        }
        if (this.cursors.left.isDown) {
            this.player.body.velocity.x = -150;
        } else if (this.cursors.right.isDown) {
            this.player.body.velocity.x = 150;
        }
        this.game.physics.arcade.collide(this.player, this.layers.last);
    }
}

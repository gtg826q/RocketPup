var Hero = require('Hero');
var Scroller = require('Scroller');

var State = cc.Enum({
    Menu: -1,
    Run : -1,
    Over: -1
});

var GameManager = cc.Class({
    extends: cc.Component,
    properties: {
        hero: Hero,
        gameOverMenu: cc.Node,
        scoreText: cc.Label
    },

    statics: {
        State
    },

    onLoad () {
        D.GameManager = GameManager;
        D.game = this;

        cc.director.getCollisionManager().enabled = true;
   
        this.state = State.Menu;

        this.highscore = 0;

        if (cc.sys.localStorage.getItem("highscore") > 0) {
            this.highscore = cc.sys.localStorage.getItem("highscore");
        }

        this.score = 0;
        this.scoreText.string = this.score;
        this.gameOverMenu.active = false;
        this.hero.init();
    },

    start () {
        this.state = State.Run;
        this.score = 0;
        D.pipeManager.startSpawn();
        D.goalManager.startSpawn();
        this.hero.startRun();  
    },

    gameOver () {


        D.pipeManager.reset();
        D.goalManager.reset();
        this.state = State.Over;
        this.gameOverMenu.active = true;
    },

    gainScore () {

        this.score++;
        this.scoreText.string = this.score;

        if (this.score > this.highscore) {
            this.highscore = this.score;
        }

    }
});

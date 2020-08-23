var GameOverMenu = cc.Class({

    extends: cc.Component,

    properties: {
        gameOverBtn: cc.Button,
        score: cc.Label
    },

    restart: function () {
        cc.sys.localStorage.setItem("highscore", D.game.highscore);
        cc.director.loadScene('StartGame');
    },
});

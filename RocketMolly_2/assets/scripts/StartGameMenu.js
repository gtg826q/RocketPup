var StartGameMenu = cc.Class({

    extends: cc.Component,

    properties: {
        startGameBtn: cc.Button,
        score: cc.Label
    },

    onLoad: function () {
        if (cc.sys.localStorage.getItem("highscore") > 0) {
            this.highscore = cc.sys.localStorage.getItem("highscore");
        } else {
            this.highscore = 0;
        }    

        this.score.string = this.score.string + " " + this.highscore;
    },

    start: function () {
        cc.eventManager.pauseTarget(this.startGameBtn, true);
    },


    enableButton: function () {
        cc.eventManager.resumeTarget(this.startGameBtn, true);
    },

    playGame: function () {
        cc.eventManager.pauseTarget(this.startGameBtn, true);
        cc.director.loadScene('PlayGame');
    }    
});





const GoalGroup = require('GoalGroup');

cc.Class({
    extends: cc.Component,
    properties: {
        goalPrefab: cc.Prefab,

        spawnInterval: 2
    },
    onLoad () {
        D.goalManager = this;
    },
    startSpawn () {
        this.spawnGoal();
        this.schedule(this.spawnGoal, this.spawnInterval);
    },

    spawnGoal () {
        var goal = D.sceneManager.spawn(this.goalPrefab, GoalGroup);
        goal.node.y = -270 + Math.random() * (325 + 270);
        goal.node.x = Math.random() * (325 + 270);
    },
    reset () {
        this.unschedule(this.spawnGoal);
    }
});

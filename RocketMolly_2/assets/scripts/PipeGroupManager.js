const PipeGroup = require('PipeGroup');

cc.Class({
    extends: cc.Component,
    properties: {
        pipePrefab: cc.Prefab,

        spawnInterval: 0
    },
    onLoad () {
        D.pipeManager = this;
    },
    startSpawn () {
        this.spawnPipe();
        this.schedule(this.spawnPipe, this.spawnInterval);
    },

    spawnPipe () {
        D.sceneManager.spawn(this.pipePrefab, PipeGroup);
    },
    reset () {
        this.unschedule(this.spawnPipe);
    }
});

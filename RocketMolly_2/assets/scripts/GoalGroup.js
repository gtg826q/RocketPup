cc.Class({
    extends: require('SceneObject'),
    properties: {
    },
    onEnable () {
    },
    onCollisionEnter () {
        D.sceneManager.despawn(this);
    }
});

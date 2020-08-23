
var State = cc.Enum({
    None   : -1,
    Run    : -1,
    Jump   : -1,
    Drop   : -1,
    DropEnd: -1,
    Dead   : -1
});
var Hero = cc.Class({

    extends: cc.Component,

    properties: {

        maxY: 0,

        groundY: 0,

        gravity: 0,

        initJumpSpeed: 0,

        _state: {
            default: State.None,
            type: State,
            visible: false
        },
        state: {
            get: function () {
                return this._state;
            },
            set: function(value){
                if (value !== this._state) {
                    this._state = value;
                    if (this._state !== State.None) {
                        this._updateAnimation();
                    }
                }
            },
            type: State
        },
        normalSpeed: -300
    },
    statics: {
        State: State
    },
    init () {
        D.hero = this;

        this.anim = this.getComponent(cc.Animation);

        this.currentSpeed = 0;
 
        this.sprite = this.getComponent(cc.Sprite);
        this.registerInput();
    },
    startRun () {
        this.state = State.Run;
        this.state = State.Drop;
        this.enableInput(true);
    },

    registerInput () {

        cc.systemEvent.on(cc.SystemEvent.EventType.KEY_DOWN, () => {
            this.jump();
        }, this.node);

        cc.find('Canvas').on(cc.Node.EventType.TOUCH_START, () => {
            this.jump();
        }, this.node);
    },

    cancelListener () {
        cc.systemEvent.off(cc.SystemEvent.EventType.KEY_DOWN);
        cc.find('Canvas').off(cc.Node.EventType.TOUCH_START);
    },


    enableInput: function (enable) {
        if (enable) {
            this.registerInput();
        } else {
            this.cancelListener();
        }
    },

    update (dt) {
        switch (this.state) {
            case State.Jump:
                if (this.currentSpeed < 0) {
                    this.state = State.Drop;
                } 
                break;
            case State.Drop:
                if (this.node.y < this.groundY) {
                    this.node.y = this.groundY;
                    this.state = State.DropEnd;
                }
                break;
            case State.None:
            case State.Dead:
                return;
        }

       var flying = this.state === State.Jump || this.node.y > this.groundY;
        if (flying) {
            this.currentSpeed -= dt * this.gravity;
            this.node.y += dt * this.currentSpeed;
        }

    },

    _updateAnimation () {
        var animName = 'Hero';
        this.anim.stop();
        this.anim.play(animName);
    },

    onDropFinished () {
        this.state = State.Run;
    },

    onCollisionEnter: function (other) {
        if (this.state !== State.Dead) {
            var group = cc.game.groupList[other.node.groupIndex];
            switch (group) {
                case 'Obstacle':
                    this.state = Hero.State.Dead;
                    D.game.gameOver();
                    this.enableInput(false);
                    break;
                case 'Goal':
                    D.game.gainScore();
                    break;
            }
       }
    },

    jump: function () {
            this.state = State.Jump;
            this.currentSpeed = this.initJumpSpeed;
    }   
});

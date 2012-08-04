package caterbash;

import hopscotch.input.digital.Button;
import nme.installer.Assets;
import hopscotch.graphics.Image;
import hopscotch.Playfield;

class Title extends Playfield {
    public var startButton:Button;

    public var onPlay:Void->Void;

    public function new(startButton:Button) {
        super();

        this.startButton = startButton;

        var graphic = new Image(Assets.getBitmapData("assets/Title.png"));
        addGraphic(graphic);
    }

    override public function update(frame:Int) {
        if (startButton.pressed) {
            onPlay();
        }
    }
}
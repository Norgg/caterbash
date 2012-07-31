package hopscotch.graphics;

import hopscotch.Static;
import flash.geom.ColorTransform;
import flash.text.TextFormat;
import hopscotch.errors.IllegalOperationError;
import flash.text.TextField;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.display.BitmapData;
import hopscotch.engine.ScreenSize;

class Text implements IGraphic {
    public var active:Bool;
    public var visible:Bool;

    public var x:Float;
    public var y:Float;
    public var width:Float;
    public var height:Float;

    public var text:String;

    public var fontFace:FontFace;
    public var fontSize:Float;
    public var color:UInt;
    public var alpha:Float;

    public var wordWrap:Bool;
    public var autoSize:Bool;

    var textFormat:TextFormat;
    var textField:TextField;

    public function new() {
        active = false;
        visible = true;

        x = 0;
        y = 0;
        width = 0;
        height = 0;

        text = "";

        fontFace = FontFace.sans;
        fontSize = 16;
        color = 0x000000;
        alpha = 1;

        wordWrap = false;
        autoSize = true;

        textFormat = new TextFormat();
        textFormat.font = fontFace.name;
        textFormat.size = fontSize;

        textField = new TextField();
    }

    public function measure(outSize:Point) {
        updateTextField();

        outSize.x = textField.width;
        outSize.y = textField.height;
    }

    public function beginGraphic(frame:Int) {
    }

    public function endGraphic():Void {
    }

    public function updateGraphic(frame:Int, screenSize:ScreenSize) {
    }

    public function render(target:BitmapData, position:Point, camera:Matrix) {
        updateTextField();

        Static.matrix.a = Static.matrix.d = 1;
        Static.matrix.b = Static.matrix.c = 0;
        Static.matrix.tx = position.x + x + camera.tx;
        Static.matrix.ty = position.y + y + camera.ty;

        Static.rect.x = Math.floor(Static.matrix.tx);
        Static.rect.y = Math.floor(Static.matrix.ty);
        Static.rect.width = Math.ceil(textField.width + 1);
        Static.rect.height = Math.ceil(textField.height + 1);

        var colorTransform:ColorTransform = null;
        if (alpha < 1) {
            colorTransform = Static.colorTransform;
            colorTransform.redMultiplier = 1;
            colorTransform.greenMultiplier = 1;
            colorTransform.blueMultiplier = 1;
            colorTransform.redOffset = 0;
            colorTransform.greenOffset = 0;
            colorTransform.blueOffset = 0;
            colorTransform.alphaMultiplier = alpha;
            colorTransform.alphaOffset = 0;
        }

        target.draw(textField, Static.matrix, colorTransform, null, Static.rect, true);
    }

    function updateTextField() {
        if (fontFace == null) {
            throw new IllegalOperationError("fontFace must not be null");
        }

        var updated = false;

        if (textField.embedFonts != fontFace.embedded) {
            textField.embedFonts = fontFace.embedded;
            updated = true;
        }

        if (textFormat.font != fontFace.name) {
            textFormat.font = fontFace.name;
            updated = true;
        }

        if (textFormat.size != fontSize) {
            textFormat.size = fontSize;
            updated = true;
        }

        if (textFormat.color != color) {
            textFormat.color = color;
            updated = true;
        }

        if (textField.text != text) {
            textField.text = text;
            updated = true;
        }

        if (updated) {
            textField.setTextFormat(textFormat);
        }

        if (autoSize) {
            if (wordWrap) {
                updated = updated || textField.width != width;
            }

            if (updated) {
                if (wordWrap) {
                    textField.width = width;
                    textField.height = textField.textHeight + 4;
                } else {
                    textField.width = textField.textWidth + 4;
                    textField.height = textField.textHeight + 4;
                }
            }
        } else {
            if (textField.width != width) {
                textField.width = width;
            }

            if (textField.height != height) {
                textField.height = height;
            }
        }
    }
}

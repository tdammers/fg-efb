include('baseApp.nas');
include('gui/pager.nas');
include('gui/keyboard.nas');

var KneepadApp = {
    new: func(masterGroup) {
        var m = BaseApp.new(masterGroup);
        m.parents = [me] ~ m.parents;
        m.scrollY = 0;
        m.text = [];
        m.editing = 0;
        m.cursor = { row: 0, col: 0 };
        return m;
    },

    handleBack: func () {
    },

    initialize: func () {
        var self = me;
        me.metrics = {
            fontSize: 24,
            lineHeight: 38,
            font: 'sans',
            marginTop: 40,
            marginLeft: 5,
        };

        me.pageWidgets = [];

        me.bgfill = me.masterGroup.createChild('path')
                        .rect(0, 0, 512, 768)
                        .setColorFill(1, 1, 1);
        me.textGroup = me.masterGroup.createChild('group')
                         .setTranslation(0, 0);
        me.dummyGroup = me.masterGroup.createChild('group')
                          .setTranslation(-1000, -1000);
        me.dummyText = me.dummyGroup.createChild('text')
                         .setFont(font_mapper(me.metrics.font, 'normal'))
                         .setFontSize(me.metrics.fontSize)
                         .setAlignment('left-baseline');

        me.keyboardGroup = me.masterGroup.createChild('group');
        me.keyboard = Keyboard.new(me.keyboardGroup, 0);
        me.keyboard.keyPressed.addListener(func (key) {
            self.handleKey(key);
        });

        me.cursorElem = me.textGroup.createChild('path')
                        .setColorFill(0, 0, 0)
                        .rect(0, 0, 1, me.metrics.fontSize + 4);
        me.cursorInfo = me.masterGroup.createChild('text')
                         .setFont(font_mapper(me.metrics.font, 'normal'))
                         .setFontSize(me.metrics.fontSize)
                         .setColor(0, 0, 0)
                         .setText('')
                         .setTranslation(510, 60)
                         .setAlignment('right-baseline');

        me.textElems = [];

        me.rootWidget.appendChild(me.keyboard);
        me.hideKeyboard();
    },

    showKeyboard: func () {
        me.keyboard.setActive(1);
        me.editing = 1;
        me.updateCursor();
    },

    hideKeyboard: func () {
        me.keyboard.setActive(0);
        me.editing = 0;
        me.updateCursor();
    },

    background: func {
        me.hideKeyboard();
    },

    rowToY: func (row) {
        # This gives the baseline Y coordinate.
        return (row + 1) * me.metrics.lineHeight + me.metrics.marginTop;
    },

    rowFromY: func (y) {
        return math.floor((y - me.metrics.marginTop) / me.metrics.lineHeight - 0.5);
    },

    wheel: func (axis, amount) {
        if (axis == 0) {
            me.scrollY += me.metrics.lineHeight * amount;
            me.scrollY = math.min(size(me.text) * me.metrics.lineHeight - (740 - 256), me.scrollY);
            me.scrollY = math.max(0, me.scrollY);
            me.textGroup.setTranslation(0, -me.scrollY);
            me.updateCursor();
        }
    },

    measureText: func (txt) {
        me.dummyText.setText(txt ~ '|');
        var box = me.dummyText.getBoundingBox();
        var width = box[2] - box[0];
        me.dummyText.setText('|');
        box = me.dummyText.getBoundingBox();
        width -= box[2] - box[0];
        return width;
    },

    cursorToXY: func (cursor=nil) {
        if (cursor == nil)
            cursor = me.cursor;
        var y = me.rowToY(cursor.row);
        var x = me.metrics.marginLeft;
        var box = nil;

        var txt = '';
        if (cursor.row < size(me.text)) {
            txt = me.text[cursor.row];
        }
        if (txt == nil or cursor.col == 0) {
            # just keep the left margin.
        }
        elsif (cursor.col >= size(txt)) {
            x += me.measureText(txt);
        }
        else {
            x += me.measureText(substr(txt, 0, cursor.col));
        }
        return { x: x, y: y };
    },

    cursorFromXY: func (x, y) {
        var row = me.rowFromY(y);
        var text = '';
        if (row < size(me.text)) {
            text = me.text[row];
        }
        var col = size(text);
        var prevX = me.metrics.marginLeft;
        for (var i = 0; i < size(text); i += 1) {
            var curX = me.metrics.marginLeft + me.measureText(substr(text, 0, i + 1));
            if (prevX <= x and curX >= x) {
                col = i;
                break;
            }
            prevX = curX;
        }
        return { row: math.max(0, row), col: math.max(col) };
    },

    updateCursor: func {
        me.cursorInfo.setText(sprintf("%3i:%3i %5i", me.cursor.row, me.cursor.col, me.scrollY));
        if (me.editing) {
            var xy = me.cursorToXY();
            me.cursorElem
                    .setTranslation(xy.x, xy.y - me.metrics.fontSize)
                    .show();
            me.cursorInfo.setColor(1, 0, 0);
        }
        else {
            me.cursorElem.hide();
            me.cursorInfo.setColor(0.6, 0.6, 0.6);
        }
    },

    insertChar: func (c) {
        if (size(me.text) == 0) {
            me.insertNewline();
            me.cursor.row = 0;
            me.cursor.col = 0;
        }
        if (me.cursor.row >= size(me.text))
            me.cursor.row = size(me.text) - 1;
        if (me.cursor.col >= size(me.text[me.cursor.row]))
            me.cursor.col = size(me.text[me.cursor.row]);
        me.text[me.cursor.row] =
            substr(me.text[me.cursor.row], 0, me.cursor.col) ~
            c ~
            substr(me.text[me.cursor.row], me.cursor.col);
        me.textElems[me.cursor.row].setText(me.text[me.cursor.row]);
        me.cursor.col += 1;
        me.updateCursor();
    },

    insertNewline: func {
        while (me.cursor.row >= size(me.text)) {
            append(me.text, '');
        }
        var linesBefore = subvec(me.text, 0, me.cursor.row);
        var linesAfter = subvec(me.text, me.cursor.row + 1);
        var currentLine = me.text[me.cursor.row];
        var linesMiddle = [
            substr(me.text[me.cursor.row], 0, me.cursor.col),
            substr(me.text[me.cursor.row], me.cursor.col),
        ];

        me.text = linesBefore ~ linesMiddle ~ linesAfter;

        while (size(me.textElems) < size(me.text)) {
            var y = me.rowToY(size(me.textElems));
            append(me.textElems,
                me.textGroup.createChild('text')
                  .setFont(font_mapper('sans', 'normal'))
                  .setFontSize(me.metrics.fontSize)
                  .setAlignment('left-baseline')
                  .setTranslation(me.metrics.marginLeft, y)
                  .setColor(0,0,0)
                  .setText(''));
        }

        for (var row = me.cursor.row; row < size(me.text); row += 1) {
            me.textElems[row].setText(me.text[row]);
        }

        me.cursor.row += 1;
        me.cursor.col = 0;

        me.updateCursor();
    },

    backspace: func {
        if (size(me.text) == 0)
            return;

        if (me.cursor.row > size(me.text)) {
            me.cursor.row = size(me.text);
            if (me.cursor.row >= size(me.text))
                me.cursor.col = 0;
            else
                me.cursor.col = size(me.text[me.cursor.row]);
        }

        if (me.cursor.col == 0 and me.cursor.row == 0) {
            # Already at top-left position; stop.
        }
        elsif (me.cursor.col == 0 and me.cursor.row > 0) {
            # Merge this row with the previous one
            var linesBefore = subvec(me.text, 0, me.cursor.row - 1);
            var linesMiddle = subvec(me.text, me.cursor.row - 1, 2);
            var linesAfter = subvec(me.text, math.min(size(me.text), me.cursor.row + 1));
            me.text = linesBefore ~ [ string.join('', linesMiddle) ] ~ linesAfter;
            me.cursor.row -= 1;
            me.cursor.col = size(linesMiddle[0]);
            for (var row = 0; row < size(me.textElems); row += 1) {
                if (row < size(me.text))
                    me.textElems[row].setText(me.text[row]);
                else
                    me.textElems[row].setText('');
            }
        }
        elsif (me.cursor.col > 0) {
            # Delete from this row
            me.text[me.cursor.row] =
                substr(me.text[me.cursor.row], 0, math.max(0, me.cursor.col - 1)) ~
                substr(me.text[me.cursor.row], me.cursor.col);
            me.textElems[me.cursor.row].setText(me.text[me.cursor.row]);
            me.cursor.col -= 1;
        }
        me.updateCursor();
    },

    handleKey: func (key) {
        if (key == 'enter') {
            me.insertNewline();
        }
        elsif (key == 'backspace') {
            me.backspace();
        }
        elsif (key == 'space') {
            me.insertChar(' ');
        }
        elsif (key == 'esc') {
            me.hideKeyboard();
        }
        else {
            me.insertChar(key);
        }
    },

    handleBack: func {
        if (me.editing) {
            me.hideKeyboard();
        }
    },

    touch: func (x, y) {
        if (!call(BaseApp.touch, [x, y], me))
            return 0;

        var clickpos = me.cursorFromXY(x, y + me.scrollY);
        me.cursor.row = clickpos.row;
        me.cursor.col = clickpos.col;
        if (me.cursor.row >= size(me.text)) {
            me.cursor.row = math.max(0, size(me.text) - 1);
            if (me.cursor.row < size(me.text)) {
                me.cursor.col = size(me.text[me.cursor.row]);
            }
            else {
                me.cursor.col = 0;
            }
        }
        if (me.editing) {
            me.updateCursor();
        }
        else {
            me.showKeyboard();
        }
    },
};

registerApp('kneepad', 'Kneepad', 'kneepad.png', KneepadApp);

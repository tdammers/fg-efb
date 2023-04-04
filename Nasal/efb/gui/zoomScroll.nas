include('gui/widget.nas');
include('util.nas');
include('eventSource.nas');

var ZoomScroll = {
    new: func (parentGroup) {
        var m = Widget.new();
        m.parents = [me] ~ m.parents;
        m.onScroll = EventSource.new();
        m.onZoom = EventSource.new();
        m.onReset = EventSource.new();
        m.zoom = 1;
        m.autoCenter = 0;
        m.fmtZoom = func(zoom) { sprintf('%i', zoom * 100); };
        m.fmtUnit = func(zoom) { return '%'; };
        m.initialize(parentGroup);
        return m;
    },

    setZoomFormat: func (fmtZoom, fmtUnit) {
        me.fmtZoom = fmtZoom;
        me.fmtUnit = fmtUnit;
        me.updateZoomPercent();
    },

    setZoom: func (zoom) {
        me.zoom = zoom;
        me.updateZoomPercent();
        return me;
    },

    setAutoCenter: func (enabled) {
        me.autoCenter = enabled;
        me.autoCenterMarker.setVisible(enabled);
        return me;
    },

    updateZoomPercent: func {
        me.zoomDigital.setText(me.fmtZoom(me.zoom));
        me.zoomUnit.setText(me.fmtUnit(me.zoom));
    },

    initialize: func (parentGroup) {
        me.group = parentGroup.createChild('group');
        canvas.parsesvg(me.group, acdir ~ "/Models/EFB/zoom-scroll-overlay.svg", {'font-mapper': font_mapper});

        me.autoCenterMarker = me.group.getElementById('autoCenterMarker');
        me.autoCenterMarker.hide();

        me.zoomDigital = me.group.getElementById('zoomPercent.digital');
        me.zoomUnit = me.group.getElementById('zoomPercent.unit');

        me.btnZoomIn = me.group.getElementById('btnZoomIn');
        me.btnZoomOut = me.group.getElementById('btnZoomOut');
        me.btnScrollN = me.group.getElementById('btnScrollN');
        me.btnScrollS = me.group.getElementById('btnScrollS');
        me.btnScrollE = me.group.getElementById('btnScrollE');
        me.btnScrollW = me.group.getElementById('btnScrollW');
        me.btnScrollReset = me.group.getElementById('btnScrollReset');

        var self = me;
        me.appendChild(
            Widget.new(me.btnZoomIn)
                .setHandler(func () {
                    printf("Zoom in");
                    self.onZoom.raise({amount: 1});
                }));
        me.appendChild(
            Widget.new(me.btnZoomOut)
                .setHandler(func () {
                    printf("Zoom out");
                    self.onZoom.raise({amount: -1});
                }));
        me.appendChild(
            Widget.new(me.btnScrollN)
                .setHandler(func () {
                    self.onScroll.raise({x: 0, y: 1});
                }));
        me.appendChild(
            Widget.new(me.btnScrollS)
                .setHandler(func () {
                    self.onScroll.raise({x: 0, y: -1});
                }));
        me.appendChild(
            Widget.new(me.btnScrollE)
                .setHandler(func () {
                    self.onScroll.raise({x: 1, y: 0});
                }));
        me.appendChild(
            Widget.new(me.btnScrollW)
                .setHandler(func () {
                    self.onScroll.raise({x: -1, y: 0});
                }));
        me.appendChild(
            Widget.new(me.btnScrollReset)
                .setHandler(func () {
                    printf("Reset");
                    self.onReset.raise({});
                }));

    },
};


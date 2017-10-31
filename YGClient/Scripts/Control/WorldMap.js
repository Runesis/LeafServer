"use strict";

function drawWorldMap() {
    var WorldMap = document.getElementById('MapCanvas');
    if (WorldMap && WorldMap.getContext) {
        var mapContext = WorldMap.getContext("2d"),
            worldMapImg = new Image();

        // TODO : ImageSize에 맞춰야 함
        WorldMap.width = 476;
        WorldMap.height = 640;
        mapContext.height = worldMapImg.height;
        worldMapImg.onload = function () {
            mapContext.drawImage(worldMapImg, 0, 0, 476, 640);
        };
        worldMapImg.src = 'Content/img/worldMap.png';
    }
}

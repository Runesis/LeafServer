"use strict";

function drawAvatar(canvas, equipList, direction) {
    var CharCanvas = document.getElementById(canvas);
    if (CharCanvas && CharCanvas.getContext) {
        // Avatar ImageSize
        var w = 406, h = 695;
        function loadImages(sources, callback) {
            var images = {};
            for (var src in sources.hair) {
                var target = sources.hair[src];
                images[target.id] = new Image();
                images[target.id].onload = function () {
                    callback(images);
                };
                images[target.id].src = target.src;
            }
            for (var src in sources.body) {
                var target = sources.body[src];
                images[target.id] = new Image();
                images[target.id].onload = function () {
                    callback(images);
                };
                images[target.id].src = target.src;
            }
            for (var src in sources.clothes) {
                var target = sources.clothes[src];
                images[target.id] = new Image();
                images[target.id].onload = function () {
                    callback(images);
                };
                images[target.id].src = target.src;
            }
            for (var src in sources.face) {
                var parts = sources.face[src];
                for (var objsrc in parts.eye) {
                    var facePart = parts.eye[objsrc];
                    images[facePart.id] = new Image();
                    images[facePart.id].onload = function () {
                        callback(images);
                    };
                    images[facePart.id].src = facePart.src;
                }
                for (var objsrc in parts.eyebrow) {
                    var facePart = parts.eyebrow[objsrc];
                    images[facePart.id] = new Image();
                    images[facePart.id].onload = function () {
                        callback(images);
                    };
                    images[facePart.id].src = facePart.src;
                }
                for (var objsrc in parts.mouth) {
                    var facePart = parts.mouth[objsrc];
                    images[facePart.id] = new Image();
                    images[facePart.id].onload = function () {
                        callback(images);
                    };
                    images[facePart.id].src = facePart.src;
                }
                for (var objsrc in parts.voltouch) {
                    var facePart = parts.voltouch[objsrc];
                    images[facePart.id] = new Image();
                    images[facePart.id].onload = function () {
                        callback(images);
                    };
                    images[facePart.id].src = facePart.src;
                }
            }
            console.log("Load Resource");
        }

        var ctx = CharCanvas.getContext("2d"),
            charResource = {
                hair: [
                    { id: "Hair_M", src: "Content/img/Character/Hair_M_01.png" },
                    { id: "Hair_W", src: "Content/img/Character/Hair_W_01.png" }
                ],
                body: [
                    { id: "Body_M", src: "Content/img/Character/Body_M.png" },
                    { id: "Body_W", src: "Content/img/Character/Body_W.png" }
                ],
                clothes: [
                    { id: "Cloth_M", src: "Content/img/Character/Clothes_M_Basic.png" },
                    { id: "Cloth_W", src: "Content/img/Character/Clothes_W_Basic.png" }
                ],
                face: [
                    {
                        eye: [
                            { id: "Eye_01", src: "Content/img/Character/Face_Eye_01.png" },
                            { id: "Eye_02", src: "Content/img/Character/Face_Eye_02.png" }
                        ],
                        eyebrow: [
                            { id: "Eyebrow_01", src: "Content/img/Character/Face_Eyebrow_01.png" },
                            { id: "Eyebrow_02", src: "Content/img/Character/Face_Eyebrow_02.png" }
                        ],
                        mouth: [
                            { id: "Mouth_01", src: "Content/img/Character/Face_Mouth_01.png" },
                            { id: "Mouth_02", src: "Content/img/Character/Face_Mouth_02.png" },
                            { id: "Mouth_03", src: "Content/img/Character/Face_Mouth_03.png" }
                        ],
                        voltouch: [
                            { id: "Voltouch_01", src: "Content/img/Character/Face_Voltouch_01.png" },
                            { id: "Voltouch_02", src: "Content/img/Character/Face_Voltouch_02.png" }
                        ]
                    }
                ]
            };

        // CanvasSize
        CharCanvas.width = 120;
        CharCanvas.height = 250;

        if (!direction) {
            ctx.translate(CharCanvas.width, 0);
            ctx.scale(-1, 1);
        }

        loadImages(charResource, function (img) {
            if (equipList.body && equipList.body != "")
                ctx.drawImage(img[equipList.body], 0, 0, w / 3, h / 3);
            if (equipList.clothes && equipList.clothes != "")
                ctx.drawImage(img[equipList.clothes], 0, 0, w / 3, h / 3);
            if (equipList.hair && equipList.hair != "")
                ctx.drawImage(img[equipList.hair], 0, 0, w / 3, h / 3);
            if (equipList.eye && equipList.eye != "")
                ctx.drawImage(img[equipList.eye], 0, 0, w / 3, h / 3);
            if (equipList.eyebrow && equipList.eyebrow != "")
                ctx.drawImage(img[equipList.eyebrow], 0, 0, w / 3, h / 3);
            if (equipList.mouth && equipList.mouth != "")
                ctx.drawImage(img[equipList.mouth], 0, 0, w / 3, h / 3);
            if (equipList.voltouch && equipList.voltouch != "")
                ctx.drawImage(img[equipList.voltouch], 0, 0, w / 3, h / 3);
        });
    }
};

function changeDirection(canvas, direction) {
    var CharCanvas = document.getElementById(canvas);
    if (CharCanvas && CharCanvas.getContext) {
        var ctx = CharCanvas.getContext("2d");
        ctx.scale(-1, 1);
    }
};
"use strict";

$().ready(function () {
    MainLoad(false);

    drawWorldMap();

    var equip = {
        body: "Body_W",
        clothes: "Cloth_W",
        hair: "Hair_W",
        eye: "Eye_01",
        eyebrow: "Eyebrow_01",
        mouth: "Mouth_01",
        voltouch: "Voltouch_01"
    },
        equip2 = {
            body: "Body_M",
            clothes: "Cloth_M",
            hair: "Hair_M",
            eye: "Eye_02",
            eyebrow: "Eyebrow_02",
            mouth: "Mouth_03",
            voltouch: "Voltouch_02",
        };

    drawAvatar("CharCanvas", equip, true);
    drawAvatar("CharCanvas2", equip2, false);

    var direction = true;
    $(window).click(function (e) {
        drawAvatar("CharCanvas", equip, direction)
        if (direction)
            direction = false;
        else
            direction = true;
    });
});

function showScreen(screenId) {
    var activeScreen = $("#Client .Screen.Active")[0];

    if (activeScreen)
        $("#Client .Screen.Active").removeClass("Active");
    $("#" + screenId).addClass('Active');
};

function isValidEmailAddress(emailAddress) {
    var pattern = /^([a-z\d!#$%&'*+\-\/=?^_`{|}~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+(\.[a-z\d!#$%&'*+\-\/=?^_`{|}~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+)*|"((([ \t]*\r\n)?[ \t]+)?([\x01-\x08\x0b\x0c\x0e-\x1f\x7f\x21\x23-\x5b\x5d-\x7e\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]|\\[\x01-\x09\x0b\x0c\x0d-\x7f\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))*(([ \t]*\r\n)?[ \t]+)?")@(([a-z\d\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]|[a-z\d\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF][a-z\d\-._~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]*[a-z\d\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])\.)+([a-z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]|[a-z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF][a-z\d\-._~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]*[a-z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])\.?$/i;
    return pattern.test(emailAddress);
};
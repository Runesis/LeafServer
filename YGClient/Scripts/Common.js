"use strict";

$().ready(function () {

    // 참조링크 : https://stephanwagner.me/jBox

    $('#navHome').click(function () {
        new jBox('Notice', {
            theme: 'NoticeFancy',
            attributes: {
                x: 'left',
                y: 'bottom'
            },
            color: getColor(),
            content: getString(),
            title: getTitle(),
            maxWidth: 600,
            audio: '/Content/jbox/audio/bling2',
            volume: 80,
            autoClose: Math.random() * 8000 + 2000,
            animation: { open: 'slide:bottom', close: 'slide:left' },
            delayOnHover: true,
            showCountdown: true,
            closeButton: true
        });
    });

    new jBox('Modal', {
        attach: '#navOption',
        width: 350,
        height: 200,
        blockScroll: false,
        animation: 'zoomIn',
        draggable: 'title',
        closeButton: true,
        content: '<h3>You can move this modal window</h3>',
        title: 'Option',
        overlay: false,
        reposition: false,
        repositionOnOpen: false
    });

    $('#navOption').click(function () {

    });

    var colors = ['red', 'green', 'blue', 'yellow'], index = 0;
    var getColor = function () {
        (index >= colors.length) && (index = 0);
        return colors[index++];
    };
    var strings = ['Short', 'You just switched the internet off', 'Please do not click too hard - next time we\'ll notify google.', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'];
    var getString = function () {
        return strings[Math.floor(Math.random() * strings.length)];
    };

    var titles = ['Congrats', 'Success', 'Thank you', false, false, false];
    var getTitle = function () {
        return titles[Math.floor(Math.random() * strings.length)];
    };

    //MainLoad(false);
    //drawWorldMap();

    //var equip = {
    //    body: "Body_W",
    //    clothes: "Cloth_W",
    //    hair: "Hair_W",
    //    eye: "Eye_01",
    //    eyebrow: "Eyebrow_01",
    //    mouth: "Mouth_01",
    //    voltouch: "Voltouch_01"
    //},
    //    equip2 = {
    //        body: "Body_M",
    //        clothes: "Cloth_M",
    //        hair: "Hair_M",
    //        eye: "Eye_02",
    //        eyebrow: "Eyebrow_02",
    //        mouth: "Mouth_03",
    //        voltouch: "Voltouch_02",
    //    };

    //drawAvatar("CharCanvas", equip, true);
    //drawAvatar("CharCanvas2", equip2, false);

    //var direction = true;
    //$('#CharCanvas').click(function (e) {
    //    drawAvatar("CharCanvas", equip, direction)
    //    if (direction)
    //        direction = false;
    //    else
    //        direction = true;
    //});
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
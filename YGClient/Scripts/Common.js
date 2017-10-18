"use strict";

$().ready(function () {
});

function showScreen(screenId) {
    var activeScreen = $("#Client .Screen.Active")[0];

    if (activeScreen)
        $("#Client .Screen.Active").removeClass("Active");
    $("#" + screenId).addClass('Active');
}

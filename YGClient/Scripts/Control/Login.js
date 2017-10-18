"use strict";

var formType = 'login';

$().ready(function () {
    $('.message a').click(function () {
        $('form').animate({ height: "toggle", opacity: "toggle" }, "slow", function () {
            if (formType == 'login') {
                $('#logEmail').val('');
                $('#logPassword').val('');
                formType = 'reg'
            }
            else {
                $('#regEmail').val('');
                $('#regPassword').val('');
                $('#privatenum').val('');
                formType = 'login';
            }
        });
    });

    $('form.login-form button').click(function () {
        Login();
    });
});

function MainLoad(loadFlag) {
    if (loadFlag) {
        $('div.background').fadeIn(3000, function () {
            $('div.form').fadeIn(1800).queue(function () {
                $('div.form').css('display', 'block');
                console.log("login form load complete");
            });
        });
    }
    else {
        $('div.background').css('display', 'block');
    }
}

function Login() {
    var logId = $('#logEmail').val();
    var logPass = $('#logPassword').val();

    if (logId.length < 1 || logPass.length < 4 || !isValidEmailAddress(logId))
        alert('입력이 올바르지 않습니다');
    else {
        showScreen('WorldMap');
    }
}

function Register()
{ }
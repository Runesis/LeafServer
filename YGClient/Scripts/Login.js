"use strict";

var formType = 'login';

$().ready(function () {
    $('div.background').fadeIn(3000, function () {
        $('div.form').fadeIn(1800).queue(function () {
            $('div.form').css('display', 'block');
            console.log("login form load complete");
        });
    });

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

function Login()
{
    showScreen('WorldMap');
}

function Register()
{ }
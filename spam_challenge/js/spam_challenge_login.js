/**
 * @file
 * Pre-populate the login password field.
 */

(function($) {

Backdrop.behaviors.spamChallengeLogin = {
  attach: function(context, settings) {

    $('#edit-pass').val('d8b4uTTk6Mu7DBz7fe4B2u5G7DrQD1');

  }
};

})(jQuery);

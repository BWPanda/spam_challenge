/**
 * @file
 * Pre-populate the login password field.
 */

(function($) {

Backdrop.behaviors.spamChallengeLogin = {
  attach: function(context, settings) {

    $('#edit-pass').val('Ct4-R8Gv9G$r3~E+p1v*');

  }
};

})(jQuery);

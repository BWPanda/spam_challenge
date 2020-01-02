<?php
/**
 * Custom theme functions for the Spam Challenge install profile.
 */

/**
 * Implements hook_preprocess_template().
 */
function spam_challenge_theme_preprocess_maintenance_page(&$variables) {
  // Use a sub-string of the random key to avoid cheating.
  $variables['login_url'] = '/user/login?key=' . substr(config_get('spam_challenge.config', 'key'), 0, 5);
  $variables['login_icon'] = base_path() . backdrop_get_path('theme', 'spam_challenge_theme') . '/images/padlock.png';
}

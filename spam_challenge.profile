<?php
/**
 * @file
 * Enables modules and site configuration for a Spam Challenge site
 * installation.
 */

/**
 * Implements hook_form_FORM_ID_alter() for install_configure_form().
 *
 * Allows the profile to alter the site configuration form.
 */
function spam_challenge_form_install_configure_form_alter(&$form, $form_state) {
  // Pre-populate the site name with the server name.
  $form['site_information']['site_name']['#default_value'] = $_SERVER['SERVER_NAME'];

  $form['#submit'][] = 'spam_challenge_form_install_configure_submit';
}

/**
 * Extra submit handler install_configure_form().
 */
function spam_challenge_form_install_configure_submit($form, &$form_state) {
  // Update the home page hero block to use the site name.
  $layout = layout_load('home');
  foreach ($layout->content as &$block) {
    if ($block->delta === 'hero') {
      $block->settings['title'] = st('Welcome to !sitename!', array('!sitename' => $form_state['values']['site_name']));
      break;
    }
  }
  $layout->save();
}

/**
 * Implements hook_menu().
 */
function spam_challenge_menu() {
  // Use the random key in the URL to avoid cheating.
  return array(
    'spam-challenge--' . config_get('spam_challenge.config', 'key') => array(
      'title' => 'Congratulations!',
      'page callback' => 'spam_challenge_congrats',
      'access callback' => TRUE,
      'type' => MENU_CALLBACK,
    ),
  );
}

/**
 * The Congratulations! page.
 */
function spam_challenge_congrats() {
  // Hide messages so page doesn't get pushed down (can happen when
  // bulk-deleting users).
  unset($_SESSION['messages']);

  $markup = '';
  $markup .= '<div class="spam-challenge-congrats">';
  $markup .= t('<h3>You successfully completed the Backdrop Spam Challenge!</h3>');
  $markup .= '<img src="' . base_path() . backdrop_get_path('profile', 'spam_challenge') . '/images/medal.png">';
  $markup .= t("<p>If you'd like to share your success on social media, feel free to use the above image and put a link to <a href=\"https://panda.id.au\">LINK</a> so others can try the challenge too.</p>");
  $markup .= '<p><small>Original gold medal image made by <a href="https://www.flaticon.com/authors/roundicons" title="Roundicons">Roundicons</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a>.</small></p>';
  $markup .= '</div>';

  return $markup;
}

/**
 * Implements hook_form_FORM_ID_alter() for user_login.
 */
function spam_challenge_form_user_login_alter(&$form, &$form_state, $form_id) {
  $key = $_GET['key'];

  // If the correct key is present, autofill the username & password.
  // The password must be filled via JS as there's no Form API way to do this
  // for Password fields.
  if ($key && $key == substr(config_get('spam_challenge.config', 'key'), 0, 5)) {
    backdrop_add_js(backdrop_get_path('profile', 'spam_challenge') . '/js/spam_challenge_login.js');
    $form['name']['#default_value'] = 'admin';
  }
}

/**
 * Implements hook_form_FORM_ID_alter() for views_form_node_admin_content_page.
 */
function spam_challenge_form_views_form_node_admin_content_page_alter(&$form, &$form_state, $form_id) {
  // Deny access to bulk form for anyone without the 'administer nodes'
  // permission.
  if (!user_access('administer nodes')) {
    $form['bulk_form']['#access'] = FALSE;
    $form['header']['bulk_form']['#access'] = FALSE;
  }
}

/**
 * Implements hook_node_delete().
 */
function spam_challenge_node_delete(Node $node) {
  $config = config('spam_challenge.config');

  // If this was a spam node, update our list.
  $spam_nodes = $config->get('spam.nodes');
  if (in_array($node->nid, $spam_nodes)) {
    $key = array_search($node->nid, $spam_nodes);
    unset($spam_nodes[$key]);
    $config->set('spam.nodes', $spam_nodes);
    $config->save();

    // Check if challenge complete.
    spam_challenge_complete($config);
  }
}

/**
 * Implements hook_user_delete().
 */
function spam_challenge_user_delete($account) {
  $config = config('spam_challenge.config');

  // If this was a spam user, update our list.
  $spam_users = $config->get('spam.users');
  if (in_array($account->uid, $spam_users)) {
    $key = array_search($account->uid, $spam_users);
    unset($spam_users[$key]);
    $config->set('spam.users', $spam_users);
    $config->save();

    // Check if challenge complete.
    spam_challenge_complete($config);
  }
}

/**
 * Checks if the challenge is complete (all spam deleted) and redirects to the
 * Congratulations! page if so.
 */
function spam_challenge_complete($config) {
  // Get remaining spam.
  $spam_nodes = $config->get('spam.nodes');
  $spam_users = $config->get('spam.users');

  // If no more spam, go to the Congrats page.
  if (empty($spam_nodes) && empty($spam_users)) {
    $path = 'spam-challenge--' . $config->get('key');
    $batch = &batch_get();

    if ($batch) {
      // Let any existing batch(es) finish before redirecting.
      $batch['destination'] = $path;
    }
    else {
      // Remove any existing redirections.
      if ($_GET['destination']) {
        unset($_GET['destination']);
      }
      backdrop_goto($path);
    }
  }
}

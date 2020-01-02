<?php
/**
 * @file
 * Default theme implementation to display a single Backdrop page while offline.
 *
 * Changes:
 * - Add link to login form.
 */
?>
<!DOCTYPE html>
<html<?php print backdrop_attributes($html_attributes); ?>>

<head>
  <?php print backdrop_get_html_head(); ?>
  <title><?php print $head_title; ?></title>
  <?php print backdrop_get_css(); ?>
  <?php print backdrop_get_js(); ?>
</head>
<body class="<?php print implode(' ', $classes); ?>">
  <div class="l-container">

    <header role="banner">
      <?php if (!empty($logo)): ?>
        <img src="<?php print $logo; ?>" alt="<?php print t('Home'); ?>" />
      <?php endif; ?>

      <?php if ($site_name || $site_slogan): ?>
        <div class="name-and-slogan">
          <?php if ($site_name): ?>
            <strong class="site-name">
              <?php print $site_name; ?>
            </strong>
          <?php endif; ?>

          <?php if ($site_slogan): ?>
            <div class="site-slogan"><?php print $site_slogan; ?></div>
          <?php endif; ?>
        </div> <!-- /.name-and-slogan -->
      <?php endif; ?>
    </header>

    <main role="main">
      <?php if (!empty($title)): ?>
        <h1><?php print $title; ?></h1>
      <?php endif; ?>

      <?php if (!empty($messages)): print $messages; endif; ?>

      <?php print $content; ?>
    </main>

    <?php if ($sidebar): ?>
      <div id="sidebar" class="sidebar">
        <?php print $sidebar ?>
      </div>
    <?php endif; ?>

    <?php if (!empty($footer)): ?>
      <footer role="contentinfo">
        <?php print $footer; ?>
      </footer>
    <?php endif; ?>

    <a href="<?php print $login_url; ?>" class="spam-challenge-login">
      <img src="<?php print $login_icon; ?>">
    </a>

  </div> <!-- /.l-container -->

</body>
</html>

<?php
/** v.04
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wpdb' );

/** MySQL database username */
define( 'DB_USER', 'bob' );

/** MySQL database password */
define( 'DB_PASSWORD', 'HvVAQ18IaRT6' );

/** MySQL hostname */
define( 'DB_HOST', 'wp-rds.catnputg5b8x.eu-west-2.rds.amazonaws.com' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */

define('AUTH_KEY',         '4{;hwgWU;h?wC8lqV@{>i1{LRa.P*0sN t`M/sc}K/6J |Y]t^hwflM6qCBK}?fJ');
define('SECURE_AUTH_KEY',  '~QJ^r@g9<q0fgYT2>dVMnb|MZDj}wxR`[F;Fjm-L X/,Oa?q]R_zuP>vR|u+M<.#');
define('LOGGED_IN_KEY',    '4H]e!SV;{`1h}!ml>AhEuzttO|%!L2)w47wWhVqYhx1Sla<%<|vSnY/f+BRSO3#6');
define('NONCE_KEY',        'xmQ?DLVH.]Ug/d+X%IJghb;:-V*|~Y 0=!i`CEkg8Vsf3Oa,68#|N;PDyirL]-#6');
define('AUTH_SALT',        '=G[frfE6wFtJ3R8aHt-(>10}!2gY{!LQ6(v0E3_^B2AR|dXX9YxwYcsjZ.=|ojvM');
define('SECURE_AUTH_SALT', '<?-,@M39-?/3*zA9x|H;dXvNp@Mj3|LMG]=}B=T]&_)KDu%@KK!31ft6hpjx3*4k');
define('LOGGED_IN_SALT',   'n*NbW2:*Ej]N&?1),~fw9yd>;lX%ph5*Wj<Ziv2~]d&fF:RIBUT0:K>tO!ZY57h2');
define('NONCE_SALT',       'ilz+ew8~m]B.,5@wiVGo/JAgXtFpz7PJv$yeT:yG %T:s,hq^}8Lg2W:f0vW9-<_'); 

/**
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

$table_prefix = 'wp_';

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';

<?php
/**
 * @file
 * Enables modules and site configuration for a standard site installation.
 */
function usergov_form_install_configure_form_alter(&$form, $form_state) {
  // Pre-populate the site name with the server name.
  $form['site_information']['site_name']['#default_value'] = "UserGov";
  $form['site_information']['site_mail']['#default_value'] = "admin@usergov.com";
  $form['admin_account']['account']['name']['#default_value'] = 'admin';
  $form['admin_account']['account']['mail']['#default_value'] = 'admin@company.com';
  $form['server_settings']['site_default_country']['#default_value'] = array('GB');
  $form['server_settings']['date_default_timezone']['#default_value'] = array('Europe/London');
  $form['update_notifications']['update_status_module']['#default_value'] = array();
}
<?php
error_reporting(NULL);
ob_start();
unset($_SESSION['error_msg']);
$TAB = 'WEB';

// Main include
include($_SERVER['DOCUMENT_ROOT']."/inc/main.php");

// Check domain argument
if (empty($_GET['domain'])) {
    header("Location: /list/web/");
    exit;
}

// Edit as someone else?
if (($_SESSION['user'] == 'admin') && (!empty($_GET['user']))) {
    $user=escapeshellarg($_GET['user']);
}

// List domain
$v_domain = escapeshellarg($_GET['domain']);
exec (VESTA_CMD."v-list-web-domain ".$user." ".$v_domain." json", $output, $return_var);
$data = json_decode(implode('', $output), true);
unset($output);

// Parse domain
$v_username = $user;
$v_domain = $_GET['domain'];
$v_ip = $data[$v_domain]['IP'];
$v_template = $data[$v_domain]['TPL'];
$v_aliases = str_replace(',', "\n", $data[$v_domain]['ALIAS']);
$valiases = explode(",", $data[$v_domain]['ALIAS']);
$v_tpl = $data[$v_domain]['IP'];
$v_cgi = $data[$v_domain]['CGI'];
$v_elog = $data[$v_domain]['ELOG'];
$v_ssl = $data[$v_domain]['SSL'];

exec (VESTA_CMD."v-reload-node ".$user." ".$v_domain." ".$v_ip, $output_pull, $return_var);


header("Location: /list/web/");
exit;

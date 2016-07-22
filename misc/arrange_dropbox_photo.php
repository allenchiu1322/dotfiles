<?php
//設定值

$conf = array();
//測試模式
$conf['dry_run'] = FALSE;
//處理照片的範圍
$conf['begin_year'] = 2014;
$conf['begin_month'] = 1;
$conf['begin_day'] = 1;
$conf['days_earlier'] = 200;
$conf['end_year'] = date('Y', time() - 86400 * $conf['days_earlier']);
$conf['end_month'] = date('m', time() - 86400 * $conf['days_earlier']);
$conf['end_day'] = date('d', time() - 86400 * $conf['days_earlier']);
//處理的目錄
$conf['base_dir'] = '/home/allen/Dropbox/Camera Uploads';
//照片處理上限
$conf['max_count'] = 100;

$conf['bin_find'] = '/usr/bin/find';
$conf['bin_sort'] = '/usr/bin/sort';
$conf['bin_wc'] = '/usr/bin/wc';
$conf['bin_head'] = '/usr/bin/head';
$conf['bin_mkdir'] = '/bin/mkdir';
$conf['bin_mv'] = '/bin/mv';

function out($msg) {
    echo($msg . PHP_EOL);
}

function escape_string($str) {
    $escape_these = array(' ');
    foreach($escape_these as $val) {
        $str = str_replace($val, '\\ ', $str);
    }
    return $str;
}

function dry_and_run($cmd) {
    global $conf;
    if ($conf['dry_run'] <> TRUE) {
        $result = exec($cmd);
        return $result;
    } else {
        out(sprintf('Executed: %s', $cmd));
    }
}

function move_files($year, $month, $day) {
    global $conf;
    out(sprintf('Finding photos taken at %d-%d-%d....', $year, $month, $day));
    $find_cmd = sprintf('%s %s -maxdepth 1 -name "%04d-%02d-%02d *" | %s | %s -l', $conf['bin_find'], escape_string($conf['base_dir']), $year, $month, $day, $conf['bin_sort'], $conf['bin_wc']);
    $result = intval(exec($find_cmd));
    if ($result > 0) {
        out(sprintf('Found %d photos', $result));
        while ($conf['max_count'] > 0) {
            $get_cmd = sprintf('%s %s -maxdepth 1 -name "%04d-%02d-%02d *" | %s | %s -n 1', $conf['bin_find'], escape_string($conf['base_dir']), $year, $month, $day, $conf['bin_sort'], $conf['bin_head']);
            $result = exec($get_cmd);
            if ($result <> '') {
                $date_dir = escape_string(sprintf('%s/%04d/%02d/%02d', $conf['base_dir'], $year, $month, $day));
                dry_and_run(sprintf('if [ ! -d %s ]; then %s -p %s; fi', $date_dir, $conf['bin_mkdir'], $date_dir));
                dry_and_run(sprintf('if [ -d %s ]; then %s %s %s; fi', $date_dir, $conf['bin_mv'], escape_string($result), $date_dir));
                $conf['max_count']--;
                out(sprintf('%s archived.', $result));
            } else {
                out('All photos taken at the date processed.');
                break;
            }
        }
    } else {
        out('No photos.');
    }
}

function main() {
    global $conf;
    $timestamp = mktime(0, 0, 0, $conf['begin_month'], $conf['begin_day'], $conf['begin_year']);
    while($conf['max_count'] > 0) {
        move_files(date('Y', $timestamp), date('m', $timestamp), date('d', $timestamp));
        $timestamp += 86400;
        $check = mktime(0, 0, 0, $conf['end_month'], $conf['end_day'], $conf['end_year']);
        if ($timestamp > $check) {
            out('Reached the period.');
            break;
        }
        if ($conf['max_count'] <= 0) {
            out('Reached the limit of one-time processing count.');
            break;
        }
    }
}

main();

?>

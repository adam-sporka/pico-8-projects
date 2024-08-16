<?php

// From
// https://gist.github.com/barkingdoginteractive/7b9fa886989fcff8596c9457be296a6f

date_default_timezone_set( 'Europe/Prague' );

DEFINE('GAME_NAME', 'club-3-by-3');
DEFINE('BEFORE_LUA', 0);
DEFINE('DURING_LUA', 1);
DEFINE('AFTER_LUA', 2);

function include_lua($results)
{
	$files = glob( "src/*.lua" );
	sort($files);
	foreach ($files as $filename)
	{
		$code = file_get_contents($filename);
		$lines = explode("\n", $code);
		$cleanlines = array();
		foreach ($lines as $line)
		{
			$line = trim($line);
			// if (substr($line, 0, 2) == "--") { continue; }
			$cleanlines[] = $line;
		}
		$code = implode("\n", $cleanlines);
		$code = str_replace(
			array('#LEFT#','#RIGHT#','#UP#','#DOWN#','#X#','#O#',"\t"),
			array('ã', 'ë', 'î', 'É', 'ó', 'é',"  "),
			$code);
		$results .= $code . "\n";
	}
	return $results;
}

$contents = file_get_contents(GAME_NAME . ".p8");
file_put_contents("backups/" . GAME_NAME . "-" . date("y-m-d-G-i-s") . ".p8", $contents);

$lines = explode("\n", $contents);

$result = "";
$stream_stage = BEFORE_LUA;
foreach($lines as $line)
{	
	switch($stream_stage)
	{
		case BEFORE_LUA:
			$result = $result . $line . "\n";
			if ($line == "__lua__")
			{
				$result = include_lua($result);
				$stream_stage = DURING_LUA;
			}
			break;
		case DURING_LUA:
			if ($line == "__gfx__")
			{
				$stream_stage = AFTER_LUA;
				$result = $result . $line . "\n";
			}
			break;
		case AFTER_LUA:
			$result = $result . $line . "\n";
	}
}

file_put_contents( GAME_NAME . ".p8", $result );
fputs(STDOUT, "Done.\n");

?>
<?php

include_once __DIR__ . '/../vendor/autoload.php';

Resque::setBackend('192.168.2.10:6379');

echo "set backend\n";

Resque::enqueue('default', '\Worker\EchoText', array(
    'name' => 'Dan',
));

echo "queued something\n";

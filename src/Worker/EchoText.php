<?php

namespace Worker;
 
class EchoText 
{
    public function perform()
    {
        $name = $this->args['name'];

        echo "Hello $name from worker\n";
    }
}

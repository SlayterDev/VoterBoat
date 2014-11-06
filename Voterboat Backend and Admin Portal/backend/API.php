<?php

	// Voterboat API
        // To be used ONLY by authenticated clients (The Voterboat mobile app)

        include('config.php');
        error_reporting(0);
        
        $parameters = $_REQUEST;
        $controller = strtolower($parameters['controller']);
        $method = strtolower($parameters['method']);

        // Check Controller Validity
        $controller_path = "controllers/{$controller}.php";
        if (file_exists($controller_path))
            include_once $controller_path;
        else
            display_error(1);
            
        // Check Method Validity
        $controller = new $controller($parameters);
        if (!method_exists($controller, $method))
            display_error(2);
            
        // Make Method Call
        $controller->$method();
?>
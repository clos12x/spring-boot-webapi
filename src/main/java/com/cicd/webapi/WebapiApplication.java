package com.cicd.webapi;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;

@SpringBootApplication
public class WebapiApplication {

	public static void main(String[] args) {
		SpringApplication.run(WebapiApplication.class, args);
	}

}


/*
 * Endpoint principal de prueba
 */
@RestController
class HelloController {

    @GetMapping("/")
    public String hello() {
        return "Hello CI/CD World!";
    }
}


/*
 * Endpoint utilizado para Health Check
 * Verifica que la aplicación se encuentre disponible
 */
@RestController
class HealthController {

    @GetMapping("/health")
    public String health() {
        return "Server Healthy!";
    }
}


/*
 * Endpoint adicional de prueba
 */
@RestController
class DateController {

    @GetMapping("/date")
    public String date() {
        return "Current Server Date: " + java.time.LocalDate.now();
    }
}


/*
 * Endpoint utilizado para demostrar Blue-Green Deployment
 * Permite identificar qué instancia responde detrás del Load Balancer
 */
@RestController
class InstanceController {


    @Autowired
    private Environment environment;


    @GetMapping("/api/instance")
    public String instance() {


        // Obtiene el nombre de la instancia desde variable de entorno
        String instance = System.getenv("INSTANCE_NAME");


        // Obtiene el puerto donde está ejecutándose Spring Boot
        String port = environment.getProperty(
                "local.server.port",
                environment.getProperty("server.port", "8080")
        );


        // Valor por defecto para desarrollo local
        if (instance == null || instance.isEmpty()) {
            instance = "LOCAL";
        }


        return "{\n" +
                "  \"instance\": \"" + instance + "\",\n" +
                "  \"port\": \"" + port + "\"\n" +
                "}";

    }
}
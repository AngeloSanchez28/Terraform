const express = require('express');
const AWS = require('aws-sdk');
const bodyParser = require('body-parser');
const { v4: uuidv4 } = require('uuid');

// Configuramos AWS DynamoDB
const dynamodb = new AWS.DynamoDB.DocumentClient();

// Configuramos la aplicación Express
const app = express();
app.use(bodyParser.json());

// Endpoint para publicar un viaje
app.post('/publicar-viaje', async (req, res) => {
    const {
        direccionorigen, ciudadorigen, provinciaorigen, departamentoorigen, distritoorigen,
        departamentodestino, ciudaddestino, provinciadestino, distritodestino, direcciondestino
    } = req.body;

    // Generamos IDs únicos para cada registro
    const idViajeDestino = uuidv4();
    const idViajeOrigen = uuidv4();

    // Preparamos los datos para DynamoDB
    const destinoParams = {
        TableName: "ViajeDestino",
        Item: {
            idviajedestino: idViajeDestino,
            ciudaddestino,
            departamentodestino,
            direcciondestino,
            provinciadestino,
            distritodestino
        }
    };

    const origenParams = {
        TableName: "ViajeOrigen",
        Item: {
            idviajeorigen: idViajeOrigen,
            ciudadorigen,
            departamentoorigen,
            direccionorigen,
            provinciaorigen,
            distritoorigen
        }
    };

    try {
        // Insertamos los datos en las tablas de DynamoDB
        await dynamodb.put(destinoParams).promise();
        await dynamodb.put(origenParams).promise();
        res.status(201).send({
            message: "Viaje publicado correctamente",
            idViajeOrigen,
            idViajeDestino
        });
    } catch (error) {
        console.error("Error al publicar el viaje:", error);
        res.status(500).send({ message: "Error al publicar el viaje", error: error.message });
    }
});
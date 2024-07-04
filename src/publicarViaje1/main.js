const AWS = require('aws-sdk');
const { v4: uuidv4 } = require('uuid');
const jwt = require('jsonwebtoken');

// Configuramos AWS DynamoDB
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
    console.log('Event:', JSON.stringify(event));

    const token = event.headers.Authorization.replace("Bearer ", "");

    let userId;
    try {
        const decoded = jwt.decode(token);
        userId = decoded.userId.toString(); 
    } catch (err) {
        console.error('Error decoding token:', err);
        return {
            statusCode: 400,
            body: JSON.stringify({ error: 'Invalid token' })
        };
    }

    try {
        const {
            direccionorigen, ciudadorigen, provinciaorigen, departamentoorigen, distritoorigen,
            departamentodestino, ciudaddestino, provinciadestino, distritodestino, direcciondestino
        } = JSON.parse(event.body);

        const idViajeDestino = uuidv4();
        const idViajeOrigen = uuidv4();

        const destinoParams = {
            TableName: process.env.VIAJE_DESTINO_TABLE,
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
            TableName: process.env.VIAJE_ORIGEN_TABLE,
            Item: {
                idviajeorigen: idViajeOrigen,
                ciudadorigen,
                departamentoorigen,
                direccionorigen,
                provinciaorigen,
                distritoorigen
            }
        };

        const viajeParams = {
            TableName: process.env.VIAJES_TABLE,
            Item: {
                id_viajes: uuidv4(),
                conductorId: userId,
                disponible: true,
                asientosReservados: 0,
                viajeOrigen: idViajeOrigen,
                viajeDestino: idViajeDestino
            }
        };

        await dynamodb.put(destinoParams).promise();
        await dynamodb.put(origenParams).promise();
        await dynamodb.put(viajeParams).promise();

        return {
            statusCode: 201,
            body: JSON.stringify({
                message: "Viaje publicado correctamente",
                idViajeOrigen,
                idViajeDestino
            }),
        };
    } catch (error) {
        console.error('Error al publicar el viaje:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ message: 'Error al publicar el viaje', error: error.message }),
        };
    }
};

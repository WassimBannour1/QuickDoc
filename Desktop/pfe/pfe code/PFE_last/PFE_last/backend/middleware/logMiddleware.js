/**
 * Middleware de journalisation des requêtes
 * Ce middleware enregistre les détails des requêtes entrantes et des réponses sortantes
 */

const logRequest = (req, res, next) => {
    const timestamp = new Date().toISOString();
    console.log(`=== ${timestamp} ===`);
    console.log(`${req.method} ${req.baseUrl}${req.path}`);
    console.log('Headers:', req.headers);
    console.log('Body:', req.body);

    // Ajout de la journalisation des réponses
    const oldSend = res.send;
    res.send = function(data) {
        console.log('Response:', data);
        oldSend.apply(res, arguments);
    };

    next();
};

module.exports = {
    logRequest
};
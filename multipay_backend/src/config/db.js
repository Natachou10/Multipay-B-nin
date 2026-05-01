const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_DATABASE,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

pool.on('connect', () => {
    // On garde juste ce petit log pour nous rassurer au démarrage
    // console.log('✅ Connecté à PostgreSQL');
});

module.exports = pool;
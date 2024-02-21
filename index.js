const express = require('express');
const mysql2 = require('mysql2/promise');
const dotenv = require('dotenv');
const hbs = require('hbs');
const wax = require('wax-on');
const handlebarHelpers = require('handlebars-helpers')({
    'handlebars': hbs.handlebars
});

dotenv.config();

let app = express();
app.use(express.urlencoded({ extended: false }));

// Set up Handlebars
app.set('view engine', 'hbs');

Object.keys(handlebarHelpers).forEach(helperName => {
    hbs.handlebars.registerHelper(helperName, handlebarHelpers[helperName]);
});

// Use Wax-On for additional Handlebars helpers
wax.on(hbs.handlebars);
wax.setLayoutPath('./views/layouts');

hbs.handlebars.registerHelper('formatDate', function (dateString) {
    const options = { day: '2-digit', month: '2-digit', year: 'numeric' };
    const formattedDate = new Date(dateString).toLocaleDateString('en-US', options);
    const [month, day, year] = formattedDate.split('/');
    const isoDate = `${day}-${month}-${year}`;
    return isoDate;
});

hbs.handlebars.registerHelper('formatDate2', function (dateString) {
    const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
    const formattedDate = new Date(dateString).toLocaleDateString('en-US', options);
    const [month, day, year] = formattedDate.split('/');
    const isoDate = `${year}-${month}-${day}`;
    return isoDate;
});

async function main(){
    const connection = await mysql2.createConnection({
        host: process.env.DB_HOST,
        user: process.env.DB_USER,
        database: process.env.DB_DATABASE,
        password: process.env.DB_PASSWORD
    });

    app.get('/', (req, res) => {
        res.redirect('/clients');
    });

    app.get('/clients', async function (req, res) {
        const [clients] = await connection.execute(`
            SELECT clients.*, consultants.first_name as c_first_name, consultants.last_name as c_last_name from clients
                LEFT JOIN consultants ON consultants.consultant_id = clients.consultant_id;
        `);
        res.render('clients/index', {
            clients
        })
    });

    app.get('/clients/create', async function (req, res) {
        const [consultants] = await connection.execute(`
            SELECT * FROM consultants;
        `);
        res.render("clients/create", {
            consultants
        });
    });

    app.post('/clients/create', async function (req, res) {
        const { first_name, last_name, birth_date, email, consultant_id } = req.body;
        const query = `
             INSERT INTO clients (first_name, last_name, birth_date, email, consultant_id) 
             VALUES (?, ?, ?, ?, ?)
        `;
        const bindings = [first_name, last_name, birth_date, email, parseInt(consultant_id)];
        await connection.execute(query, bindings);
        res.redirect('/clients');
    });

    app.get('/clients/search', async function (req, res) {

        let sql = `SELECT clients.*, consultants.first_name as c_first_name, consultants.last_name as c_last_name from clients
            LEFT JOIN consultants ON consultants.consultant_id = clients.consultant_id
            WHERE 1`;
        const bindings = [];
        if (req.query.searchTerms) {
            sql += ` AND (clients.first_name LIKE ? OR clients.last_name LIKE ?)`;
            bindings.push(`%${req.query.searchTerms}%`);
            bindings.push(`%${req.query.searchTerms}%`);
        }

        const [clients] = await connection.execute(sql, bindings);

        res.render('clients/search', {
            clients
        });
    });

    app.get('/clients/:client_id/update', async function (req, res) {
        const query = "SELECT * FROM clients WHERE client_id = ?";
        const [clients] = await connection.execute(query, [req.params.client_id]);
        const client = clients[0];
        const [consultants] = await connection.execute(`SELECT * from consultants`);
        res.render('clients/update', {
            client, consultants
        })
    });

    app.post('/clients/:client_id/update', async function (req, res) {
        const { first_name, last_name, birth_date, email, consultant_id } = req.body;
        const query = `UPDATE clients SET first_name=?,
                                            last_name =?,
                                            birth_date=?,
                                            email=?,
                                            consultant_id=?
                                        WHERE client_id = ?
        `;
        const bindings = [first_name, last_name, birth_date, email, consultant_id, req.params.client_id];
        await connection.execute(query, bindings);
        res.redirect('/clients');
    })

    app.get('/clients/:client_id/delete', async function (req, res) {
        const sql = "select * from clients where client_id = ?";
        const [clients] = await connection.execute(sql, [req.params.client_id]);
        const client = clients[0];
        res.render('clients/delete', {
            client,
        })
    });

    app.post('/clients/:client_id/delete', async function (req, res) {
        const query = "DELETE FROM clients WHERE client_id = ?";
        await connection.execute(query, [req.params.client_id]);
        res.redirect('/clients');
    });
}

main();

app.listen(3000, () => {
    console.log("Server has started");
});
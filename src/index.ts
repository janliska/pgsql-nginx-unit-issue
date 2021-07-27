import fastify from 'fastify';
import { Client } from 'pg';

const client = new Client({
  "host": "host",
  "user": "user",
  "password": "password"
});

(async (): Promise<void> => {
  const app = fastify();

  await client.connect();

  app.listen(8100, '0.0.0.0', async (err) => {
    console.log('listening...', err);
  });
})();

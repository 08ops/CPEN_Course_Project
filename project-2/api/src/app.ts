import cors from 'cors';
import express, { type Express } from 'express';
import rateLimit from 'express-rate-limit';
import helmet from 'helmet';
import morgan from 'morgan';

import { config } from './config';
import { errorHandler, notFoundHandler } from './middleware/errorHandler';
import { apiRouter } from './routes';

/**
 * Build the Express application.
 *
 * Kept separate from index.ts (which owns listen()) so the automated tests can
 * start the app on an ephemeral port without spawning a second process.
 */
export function createApp(): Express {
  const app = express();

  // Behind a reverse proxy, trust X-Forwarded-* so rate limiting sees the real
  // client IP rather than the proxy's.
  app.set('trust proxy', 1);
  app.disable('x-powered-by');

  // Security headers. The API serves JSON only, so a strict CSP costs nothing.
  app.use(
    helmet({
      contentSecurityPolicy: { directives: { defaultSrc: ["'self'"] } },
      crossOriginResourcePolicy: { policy: 'same-site' },
    }),
  );

  app.use(
    cors({
      origin: config.cors.origins.includes('*') ? true : config.cors.origins,
      methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
      allowedHeaders: ['Content-Type', 'Authorization'],
      credentials: true,
      maxAge: 86_400,
    }),
  );

  // Cap the body size: nothing this API accepts is large.
  app.use(express.json({ limit: '100kb' }));
  app.use(express.urlencoded({ extended: true, limit: '100kb' }));

  if (config.env !== 'test') {
    app.use(morgan(config.isProduction ? 'combined' : 'dev'));
  }

  app.use(
    rateLimit({
      windowMs: config.rateLimit.windowMs,
      max: config.rateLimit.max,
      standardHeaders: true,
      legacyHeaders: false,
      message: {
        success: false,
        error: {
          code: 'TOO_MANY_REQUESTS',
          message: 'Rate limit exceeded. Please slow down.',
        },
      },
    }),
  );

  // Versioned from day one so a future v2 can coexist.
  app.use('/api/v1', apiRouter);

  // Convenience redirect for anyone who opens the bare host.
  app.get('/', (_req, res) => res.redirect('/api/v1'));

  app.use(notFoundHandler);
  app.use(errorHandler);

  return app;
}

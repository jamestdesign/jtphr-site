import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const kb = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/kb' }),
  schema: z.object({
    title: z.string(),
    date: z.coerce.date().optional(),
    tags: z.array(z.string()).optional().default([]),
    category: z.string().optional().default('未分類'),
  }).passthrough(),
});

export const collections = { kb };

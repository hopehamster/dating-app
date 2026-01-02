/**
 * DeepSeek Alternative Implementation
 * 
 * DeepSeek is VERY affordable (~$0.14 per 1M input tokens, $0.56 per 1M output tokens)
 * Much cheaper than Gemini Pro, but note regulatory concerns in some regions.
 * 
 * To use this instead of Gemini:
 * 1. Get API key from https://platform.deepseek.com/
 * 2. Set DEEPSEEK_API_KEY environment variable
 * 3. Replace the ai.generate() calls in index.ts with deepseekGenerate()
 */

import { onFlow } from '@genkit-ai/firebase/functions';
import { z } from 'zod';
import { getDeepSeekApiKey, getDeepSeekModel } from './config';

const DEEPSEEK_API_URL = 'https://api.deepseek.com/v1/chat/completions';

async function deepseekGenerate(prompt: string): Promise<string> {
  const apiKey = getDeepSeekApiKey();
  if (!apiKey) {
    throw new Error('DeepSeek API key not found. Set it in api_keys.json or DEEPSEEK_API_KEY environment variable.');
  }

  const model = getDeepSeekModel();

  const response = await fetch(DEEPSEEK_API_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${apiKey}`,
    },
    body: JSON.stringify({
      model: model,
      messages: [
        {
          role: 'user',
          content: prompt,
        },
      ],
      temperature: 0.7,
      max_tokens: 500,
    }),
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`DeepSeek API error: ${response.status} - ${error}`);
  }

  const data = await response.json();
  return data.choices[0]?.message?.content || '';
}

export const generateMatchReportDeepSeek = onFlow(
  {
    name: 'generateMatchReportDeepSeek',
    inputSchema: z.object({
      userAName: z.string(),
      userBName: z.string(),
      sharedValues: z.array(z.string()),
      frictionPoints: z.array(z.string()),
    }),
    outputSchema: z.string(),
  },
  async (input) => {
    const { userAName, userBName, sharedValues, frictionPoints } = input;

    const prompt = `
      You are a relationship expert assistant for a values-based dating app.
      Analyze the compatibility between ${userAName} and ${userBName}.
      
      Shared Values: ${sharedValues.join(', ')}
      Potential Friction Points: ${frictionPoints.join(', ')}
      
      Write a concise, encouraging, but realistic match report (max 3 sentences).
      Highlight why they might click based on their shared values, but gently note what to watch out for.
      Do NOT invent facts not in the input.
    `;

    return await deepseekGenerate(prompt);
  }
);

export const suggestIceBreakersDeepSeek = onFlow(
  {
    name: 'suggestIceBreakersDeepSeek',
    inputSchema: z.object({
      sharedValues: z.array(z.string()),
    }),
    outputSchema: z.array(z.string()),
  },
  async (input) => {
    const { sharedValues } = input;

    const prompt = `
      Generate 3 unique, deep conversation starters for two people who share these values: ${sharedValues.join(', ')}.
      The questions should be open-ended and encourage vulnerability.
      Return ONLY the questions as a JSON array of strings.
    `;

    const result = await deepseekGenerate(prompt);
    const text = result.trim();
    
    // Parse JSON array
    if (!text.startsWith('[')) {
      return text.split('\n').filter(l => l.trim().length > 0).slice(0, 3);
    }
    return JSON.parse(text);
  }
);


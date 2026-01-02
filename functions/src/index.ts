
import { genkit } from 'genkit';
import { googleAI, gemini15Pro } from '@genkit-ai/googleai';
import { onFlow } from '@genkit-ai/firebase/functions';
import { z } from 'zod';

// Using Gemini 1.5 Pro for better quality (upgraded from Flash)
// For even better: try gemini20Flash or gemini3Flash if available
const ai = genkit({
  plugins: [googleAI()],
  model: gemini15Pro, // Better reasoning than Flash, still cost-effective
});

export const generateMatchReport = onFlow(
  ai,
  {
    name: 'generateMatchReport',
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

    const result = await ai.generate(prompt);
    return result.text;
  }
);

export const suggestIceBreakers = onFlow(
  ai,
  {
    name: 'suggestIceBreakers',
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

    const result = await ai.generate(prompt);
    // Basic parsing assuming model returns valid JSON or line-separated
    // ideally use structured output, but for now simple text parsing:
    const text = result.text.trim();
    // Fallback if not JSON
    if (!text.startsWith('[')) {
      return text.split('\n').filter(l => l.trim().length > 0).slice(0, 3);
    }
    return JSON.parse(text);
  }
);


/**
 * API Keys Configuration Loader
 * 
 * Reads API keys from api_keys.json file in the project root.
 * This allows easy switching between AI providers without code changes.
 */

import * as fs from 'fs';
import * as path from 'path';

interface ApiKeysConfig {
  deepseek: {
    api_key: string;
    model: string;
    enabled: boolean;
    note: string;
  };
  gemini: {
    api_key: string;
    model: string;
    enabled: boolean;
    note: string;
  };
  openai?: {
    api_key: string;
    model: string;
    enabled: boolean;
    note: string;
  };
}

let cachedConfig: ApiKeysConfig | null = null;

function loadConfig(): ApiKeysConfig {
  if (cachedConfig) {
    return cachedConfig;
  }

  // Try to find api_keys.json in project root (go up from functions/src)
  const projectRoot = path.resolve(__dirname, '../../');
  const configPath = path.join(projectRoot, 'api_keys.json');

  try {
    if (fs.existsSync(configPath)) {
      const configContent = fs.readFileSync(configPath, 'utf-8');
      cachedConfig = JSON.parse(configContent);
      return cachedConfig!;
    }
  } catch (error) {
    console.warn('Could not load api_keys.json, using environment variables:', error);
  }

  // Fallback to environment variables
  cachedConfig = {
    deepseek: {
      api_key: process.env.DEEPSEEK_API_KEY || '',
      model: 'deepseek-chat',
      enabled: false,
      note: 'Using environment variable DEEPSEEK_API_KEY',
    },
    gemini: {
      api_key: process.env.GOOGLE_API_KEY || '',
      model: 'gemini-1.5-pro',
      enabled: true,
      note: 'Using Firebase Application Default Credentials',
    },
  };

  return cachedConfig;
}

export function getDeepSeekApiKey(): string | null {
  const config = loadConfig();
  if (config.deepseek.enabled && config.deepseek.api_key) {
    return config.deepseek.api_key;
  }
  return process.env.DEEPSEEK_API_KEY || null;
}

export function getDeepSeekModel(): string {
  const config = loadConfig();
  return config.deepseek.model || 'deepseek-chat';
}

export function isDeepSeekEnabled(): boolean {
  const config = loadConfig();
  return config.deepseek.enabled === true;
}

export function getGeminiApiKey(): string | null {
  const config = loadConfig();
  if (config.gemini.api_key) {
    return config.gemini.api_key;
  }
  return process.env.GOOGLE_API_KEY || null;
}

export function getConfig(): ApiKeysConfig {
  return loadConfig();
}


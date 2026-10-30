import js from '@eslint/js'
import pluginVue from 'eslint-plugin-vue'
import { defineConfigWithVueTs, vueTsConfigs } from '@vue/eslint-config-typescript'

// Formatting is owned by Prettier; ESLint keeps the correctness rules only.
export default defineConfigWithVueTs(
  {
    ignores: [
      'dist/**',
      'coverage/**',
      'reports/**',
      '.stryker-tmp/**',
      'playwright-report/**',
      'test-results/**',
    ],
  },
  js.configs.recommended,
  pluginVue.configs['flat/essential'],
  vueTsConfigs.strictTypeChecked,
)

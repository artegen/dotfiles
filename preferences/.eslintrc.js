/**
 * Copyright © 2016-present Kriasoft.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE.txt file in the root directory of this source tree.
 */

const fs = require('fs');

const prettierOptions = JSON.parse(
  fs.readFileSync('/Users/mac/.dotfiles/preferences/.prettierrc', 'utf8')
);

// http://eslint.org/docs/user-guide/configuring
// https://github.com/prettier/prettier#eslint
module.exports = {
  parser: 'babel-eslint',
  // env: {
  //   node: true,}
  extends: ['airbnb-base', 'prettier'],
  plugins: ['flowtype', 'prettier'],
  rules: {
    'prettier/prettier': ['error', prettierOptions],
    'flowtype/define-flow-type': 1,
  },
};

// {
//   "parser": "babel-eslint",
//   "plugins": [],
//   "parserOptions": {
//     "ecmaVersion": 6,
//     "sourceType": "module"
//   },
//   "env": {
//     "node": true,
//     "mocha": true
//   },
//   "rules": {
//     "comma-dangle": 1,
//     "quotes": [ 1, "single" ],
//     "no-undef": 1,
//     "global-strict": 0,
//     "no-extra-semi": 1,
//     "no-underscore-dangle": 0,
//     "no-console": 0,
//     "no-unused-vars": 1,
//     "no-trailing-spaces": [1, { "skipBlankLines": true }],
//     "no-unreachable": 1,
//     "no-alert": 0,
//     "semi": 2
//   }
// }

// const fs = require('fs');

// const prettierOptions = JSON.parse(fs.readFileSync('./.prettierrc', 'utf8'));

// module.exports = {
//   parser: 'babel-eslint',
//   extends: ['airbnb', 'prettier', 'prettier/react'],
//   plugins: ['prettier', 'redux-saga', 'react', 'jsx-a11y'],
//   env: {
//     browser: true,
//     node: true,
//     jest: true,
//     es6: true,
//   },
//   parserOptions: {
//     ecmaVersion: 6,
//     sourceType: 'module',
//     ecmaFeatures: {
//       jsx: true,
//     },
//   },
//   rules: {
//     'prettier/prettier': ['error', prettierOptions],
//     'arrow-body-style': [2, 'as-needed'],
//     'class-methods-use-this': 0,
//     'comma-dangle': [2, 'always-multiline'],
//     'import/imports-first': 0,
//     'import/newline-after-import': 0,
//     'import/no-dynamic-require': 0,
//     'import/no-extraneous-dependencies': 0,
//     'import/no-named-as-default': 0,
//     'import/no-unresolved': 2,
//     'import/no-webpack-loader-syntax': 0,
//     'import/prefer-default-export': 0,
//     indent: [
//       2,
//       2,
//       {
//         SwitchCase: 1,
//       },
//     ],
//     'jsx-a11y/aria-props': 2,
//     'jsx-a11y/heading-has-content': 0,
//     'jsx-a11y/label-has-for': 2,
//     'jsx-a11y/mouse-events-have-key-events': 2,
//     'jsx-a11y/role-has-required-aria-props': 2,
//     'jsx-a11y/role-supports-aria-props': 2,
//     'max-len': 0,
//     'newline-per-chained-call': 0,
//     'no-confusing-arrow': 0,
//     'no-console': 1,
//     'no-use-before-define': 0,
//     'prefer-template': 2,
//     'react/jsx-closing-tag-location': 0,
//     'react/forbid-prop-types': 0,
//     'react/jsx-first-prop-new-line': [2, 'multiline'],
//     'react/jsx-filename-extension': 0,
//     'react/jsx-no-target-blank': 0,
//     'react/require-default-props': 0,
//     'react/require-extension': 0,
//     'react/self-closing-comp': 0,
//     'react/sort-comp': 0,
//     'redux-saga/no-yield-in-race': 2,
//     'redux-saga/yield-effects': 2,
//     'require-yield': 0,
//   },
//   settings: {
//     'import/resolver': {
//       webpack: {
//         config: './internals/webpack/webpack.prod.babel.js',
//       },
//     },
//   },
// };

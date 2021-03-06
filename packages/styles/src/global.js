// @flow
import { css } from '@emotion/react'
import normalize from 'normalize.css'
import type { SerializedStyles } from '@emotion/utils'

export default (css`
  ${normalize};

  html {
    font-size: 62.5%;
  }

  body {
    position: absolute;
    font-size: 1.6rem;
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
    color: var(--color-text);
    font-family: var(--font-default);
  }

  canvas {
    display: block;
  }
`: SerializedStyles)

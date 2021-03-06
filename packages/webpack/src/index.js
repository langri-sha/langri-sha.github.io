// @flow

import webpack from 'webpack'

// Stock.
export default webpack
export const { EnvironmentPlugin } = webpack
export type { WebpackOptions } from 'webpack'

// Theirs.
export { CleanWebpackPlugin as CleanPlugin } from 'clean-webpack-plugin'
export { default as CopyPlugin } from 'copy-webpack-plugin'
export { default as HtmlPlugin } from 'html-webpack-plugin'
export { default as TerserPlugin } from 'terser-webpack-plugin'

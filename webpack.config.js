const path = require('path')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const HtmlWebpackPlugin = require('html-webpack-plugin')

class DevelopmentPlugin {
  apply (compiler) {
    compiler.options.module.rules.unshift({
      enforce: 'pre',
      test: /\.js?$/,
      loader: 'standard',
      include: ours
    })
  }
}

class BailOnWarningsPlugin {
  apply (compiler) {
    if (!compiler.options.bail) return

    compiler.plugin('done', (stats) => {
      if (stats.compilation.warnings && stats.compilation.warnings.length) {
        setTimeout(process.exit.bind(process, 1), 0)
      }
    })
  }
}

module.exports = () => ({
  target: 'web',
  entry: './src/index',
  output: {
    path: resolve('srv'),
    filename: 'index.js',
    publicPath: '/'
  },
  resolve: {
    extensions: ['.js', '.css']
  },
  module: {
    rules: [{
      test: /\.js$/,
      include: ours,
      use: 'babel'
    }, {
      test: /\.css$/,
      include: ours,
      use: [
        'style',
        {
          loader: 'css',
          options: {
            modules: 1
          }
        }, {
          loader: 'postcss'
        }
      ]
    }, {
      test: /\.css$/,
      include: theirs,
      loaders: 'style!css'
    }, {
      test: /\.(eot|woff|ttf)$/,
      include: ours,
      loader: 'url'
    }]
  },
  plugins: [
    new DevelopmentPlugin(),
    new CopyWebpackPlugin([{
      from: 'share/CNAME'
    }, {
      from: 'share/keybase.txt'
    }, {
      from: 'share/robots.txt'
    }, {
      from: 'README.md'
    }, {
      from: 'LICENSE.md'
    }]),
    new HtmlWebpackPlugin({
      title: 'Langri-Sha'
    }),
    new BailOnWarningsPlugin()
  ]
})

const resolve = (...args) => (
  path.resolve(process.cwd(), ...args)
)

const ours = (absolute) => (
  absolute.startsWith(resolve('src'))
)

const theirs = (absolute) => (
  !ours(absolute)
)
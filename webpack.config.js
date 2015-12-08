const path = require('path');
const webpack = require('webpack');
const autoprefixer = require('autoprefixer');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const pkg = require('./package.json');


module.exports = {
  context: __dirname,
  watch: true,
  // devtool: 'inline-source-map',
  entry: {
    admin: [
      './www/admin/style/index.scss'
    ],
    store: [
      './www/store/style/index.scss'
    ],
    theme: [
      './www/store/style/theme/index.scss'
    ]
  },
  output: {
    path: path.join(__dirname, 'assets'),
    filename: pkg.name + '.[name]',
    publicPath: '/'
  },
  resolve: {
    extensions: ['', '.jsx', '.scss', '.js', '.json'],
    modulesDirectories: [
      'node_modules',
      path.resolve(__dirname, './node_modules')
    ]
  },
  module: {
    loaders: [
      {
        test: /(\.js|\.jsx)$/,
        exclude: /(node_modules)/,
        loader: 'babel',
        query: {
           presets:['es2015','react']
        }
      }, {
        test: /(\.scss|\.css)$/,
        loader: ExtractTextPlugin.extract('style', 'css!postcss!sass')
      }
    ]
  },

  postcss: [autoprefixer],

  plugins: [
    new ExtractTextPlugin(pkg.name + '.[name].css', { allChunks: true }),
    new webpack.NoErrorsPlugin(),
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify('development')
    })
  ]
};

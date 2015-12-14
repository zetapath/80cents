const path = require('path');
const webpack = require('webpack');
const autoprefixer = require('autoprefixer');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const pkg = require('./package.json');

module.exports = {
  context: __dirname,
  watch: true,
  devtool: 'inline-source-map',
  entry: {
    admin: [
      './www/admin/app/index.jsx'
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
    filename: pkg.name + '.[name].js',
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
        // loader: ExtractTextPlugin.extract('style', 'css!postcss!sass!toolbox')
        loader: ExtractTextPlugin.extract('style', 'css?sourceMap&modules&importLoaders=1&localIdentName=[name]__[local]___[hash:base64:5]!postcss!sass?sourceMap!toolbox')
      }
    ]
  },
  toolbox: {
    theme: path.join(__dirname, 'www/admin/app/toolbox-theme.scss')
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

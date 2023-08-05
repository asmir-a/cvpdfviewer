const HtmlWebpackPlugin = require("html-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const path = require("path");

module.exports = {
    entry: "./src/index.tsx",
    module: {
        rules: [
            {
                test: /\.tsx?$/,
                exclude: /node_modules/,
                use: {
                    loader: "babel-loader",
                }
            },
            {
                test: /\.css$/,
                use: ["style-loader", "css-loader"]
            }
        ],
    },
    resolve: {
        extensions: [".tsx", ".ts", ".js", ".css"],
    },
    plugins: [
        new HtmlWebpackPlugin({
            template: path.resolve(__dirname, "public", "index.html")
        }),
        new CopyWebpackPlugin({
            patterns: [
                {from: path.resolve(__dirname, "./build"), to: path.resolve(__dirname, "../backend/static")}
            ]
        })
    ],
    output: {
        filename: "bundle.js",
        path: path.resolve(__dirname, "./build")
    },
    devServer: {
        static: "./build",
        port: 3001,
        hot: true,
        open: true,
        historyApiFallback: true,
        proxy: {
            "/api": {
                target: "http://localhost:3000",
                secure: false
            }
        }
    },
    watchOptions: {
        ignored: [path.resolve(__dirname, "./node_modules"), path.resolve(__dirname, "./build")]
    }
}

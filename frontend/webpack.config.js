const HtmlWebpackPlugin = require("html-webpack-plugin");
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
    ],
    output: {
        filename: "bundle.js",
        path: path.join(__dirname, "build")
    },
    devServer: {
        static: "./build",
        port: 4444,
        hot: true,
        open: true,
        historyApiFallback: true,
    }
}

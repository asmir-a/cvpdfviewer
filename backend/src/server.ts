import express from "express";
import path from 'path';

const port = 3000;

const app = express();

app.use(express.static(path.resolve(__dirname, "../static")));

app.get("/api/hello", (_, res) => {
    console.log("request to hello came")
    res.send("hello");
})

app.listen(port, () => {
    console.log("started the server at port: ", port);
});
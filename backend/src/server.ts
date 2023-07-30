import express from "express";
import path from 'path';

const port = 3000;

const app = express();

app.use(express.static(path.join(__dirname, "./../static")));

//app.get("/api/hello", (req, res) => {
//    res.send("hello again again");
//});

app.listen(port, () => {
    console.log("started the server at port: ", port);
});

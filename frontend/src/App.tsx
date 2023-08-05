import React from 'react'
import {useEffect, useState} from 'react';

import "./App.css";

//dev
const App = () => {
    const [hello, setHello] = useState("");

    useEffect(() => {
        fetch("/api/hello").then(response => response.text()).then((finalResponse) => setHello(finalResponse))
    }, []);

    return (
        <div>the response from server is: {hello} yay seeming works now lol wow</div>
    )
}

export default App;
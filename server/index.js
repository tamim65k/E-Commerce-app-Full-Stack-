//Imports from packages
const express = require("express")
//const cors = require("cors")
//imports from local files
const authRouter = require("./routes/auth")
const mongoose = require("mongoose")
const adminRouter = require("./routes/admin")
const productRouter = require("./routes/product")
const userRouter = require('./routes/user')
// const serverless = require('serverless-http');


//init
const PORT = process.env.PORT || 3000
const app = express()
const DB = "Enter your DB api"


//middelWare
//client -> middelWare -> server -> client
//app.use(cors());
app.use(express.json()) // to parse JSON data from the clien
app.use(authRouter)
app.use(adminRouter)
app.use(productRouter)
app.use(userRouter)


// Connecting to MongoDB
mongoose.connect(DB).then(() => {
  console.log("Connected Successfully to MongoDB")
}).catch(e => {
  console.log("Error connecting to MongoDB", e)
})

// creating an api
// GET, PUT, POST, DELETE, UPDATE -> CRUD

app.listen(PORT, "0.0.0.0", () => {
  console.log(`connected at port ${PORT}`)
})


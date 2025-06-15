//Imports from packages
const express = require("express")

//imports from local files
const authRouter = require("./routes/auth")
const mongoose = require("mongoose")

//init
const PORT = 3000
const app = express()
const DB = "Your MongoDB Connection String Here" // replace with your MongoDB connection string


//middelWare
//client -> middelWare -> server -> client
app.use(express.json()) // to parse JSON data from the clien
app.use(authRouter)


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

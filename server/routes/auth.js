const express = require("express")
const bcryptjs = require("bcryptjs") // for hashing password
const authRouter = express.Router()
const User = require("../models/user")


authRouter.post("/api/signup", async (req, res) => {
    try {
        // get the data from client
        const { name, email, password } = req.body
        //validation, same email
        const existingUser = await User.findOne({ email })
        if (existingUser) {
            return res.status(400).json({ msg: "User already exists", })
        }

        //hash the password
        const hashedPassword = await bcryptjs.hash(password, 10)


        let user = new User({//let, var is same
            name,
            email,
            password: hashedPassword,
        })
        user = await user.save() //save the user to the database
        res.json(user)
    } catch (e) {
        console.error("Error during signup:", e)
        res.status(500).json({ error: e.message })
    }
    // post that data to the database
    // return that data to the client
})

module.exports = authRouter
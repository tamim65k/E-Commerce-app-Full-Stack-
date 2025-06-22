const express = require("express")
const bcryptjs = require("bcryptjs") // for hashing password
const authRouter = express.Router()
const User = require("../models/user")
const jwt = require("jsonwebtoken")
const auth = require("../middlewares/auth") //importing the auth middleware

authRouter.post("/api/signup", async (req, res) => {
    try {
        // get the data from client
        const { name, email, password } = req.body
        //validation, same email
        const existingUser = await User.findOne({ email })
        if (existingUser) {
            return res.status(400).json({ msg: "User already exists. Please change your email address.", })
        }
        if (password.length < 6) {
            return res.status(400).json({ msg: "Password must be at least 6 characters long." });
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

authRouter.post("/api/signin", async (req, res) => {
    try {
        // get the data from client
        const { email, password } = req.body
        //validation, same email
        const user = await User.findOne({ email })
        if (!user) {
            return res.status(400).json({ msg: "User with this email does not exist!", })
        }

        const isMatch = await bcryptjs.compare(password, user.password)
        if (!isMatch) {
            return res.status(400).json({ msg: "Incorrect Password. Please try again." })
        }

        const token = jwt.sign({ id: user._id }, "passwordKey")
        res.json({ token, ...user._doc })//...object spread operator, to return all user data except password

    } catch (e) {
        console.error("Error during sign-in:", e)
        res.status(500).json({ error: e.message })
    }

    // get the data from client



})

authRouter.post("/tokenIsValid", async (req, res) => {
    try {
        const token = req.header("auth-token")
        if (!token) return res.json(false)
        const isVerified = jwt.verify(token, "passwordKey")
        if (!isVerified) return res.json(false)
        const user = await User.findById(isVerified.id)
        if (!user) return res.json(false)
        return res.json(true)

    } catch (e) {
        res.status(500).json({ tokenValidationError: e.message })
    }
})

authRouter.get("/", auth, async (req, res) => {
    // const user = await User.findById(req.user)
    const user = await User.findById(req.user).populate('cart.product');

    res.json({ ...user._doc, token: req.token })
})

module.exports = authRouter
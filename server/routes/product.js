const express = require('express')
const productRouter = express.Router()
const auth = require('../middlewares/auth')
const { Product } = require('../models/product')

productRouter.get("/api/products", auth, async (req, res) => {
    try {
        const products = await Product.find({ category: req.query.category })
        res.json(products)
    } catch (e) {
        res.status(500).json({ error: e.message })
    }
})

productRouter.get("/api/products/search/:name", auth, async (req, res) => {
    try {
        const products = await Product.find({
            name: { $regex: req.params.name, $options: "i" }
        })
        res.json(products)
    } catch (e) {
        res.status(500).json({ error: e.message })
    }
})

// post req route to rate the product
productRouter.post("/api/rate-product", auth, async (req, res) => {
    try {

        const { id, rating } = req.body
        let product = await Product.findById(id);

        for (let i = 0; i < product.ratings.length; i++) {
            // remove existing rating
            if (product.ratings[i].userId == req.user) {
                product.ratings.splice(i, 1)
                break
            }
        }

        const ratingSchema = {
            userId: req.user,
            rating: rating
        }

        product.ratings.push(ratingSchema)
        product = await product.save()
        res.json(product)

    } catch (e) {
        res.status(500).json({ api_error: e.message })
    }
})

// get the deals of the based on the highest rating
productRouter.get('/api/deal-of-the-day', auth, async (req, res) => {

    try {

        let products = await Product.find({})
        products.sort((a, b) => {
            let aSum = 0
            let bSum = 0

            for (let i = 0; i < a.ratings.length; i++) {
                aSum += a.ratings[i].rating
            }
            for (let i = 0; i < b.ratings.length; i++) {
                bSum += b.ratings[i].rating
            }

            return aSum < bSum ? 1 : -1
        })

        // products.sort((a, b) => {
        //     const aSum = a.ratings.reduce((sum, r) => sum + r.rating, 0);
        //     const bSum = b.ratings.reduce((sum, r) => sum + r.rating, 0);
        //     return bSum - aSum; // descending order
        // });

        if (!products.length) {
            return res.status(404).json({ error: "No products found" });
        }
        res.json(products[0]);
    } catch (e) {
        res.status(500).json({ error: e.message })
    }
})

module.exports = productRouter
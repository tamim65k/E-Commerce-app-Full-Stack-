const express = require('express')
const userRouter = express.Router()
const auth = require('../middlewares/auth')
const { Product } = require('../models/product')
const User = require('../models/user')
const Order = require('../models/order')

userRouter.post('/api/add-to-cart', auth, async (req, res) => {
    try {
        const { id } = req.body // product id
        const product = await Product.findById(id)
        let user = await User.findById(req.user)

        if (user.cart.length == 0) {
            user.cart.push({ product: product._id, quantity: 1 })
        } else {
            let isProductFound = false
            for (let i = 0; i < user.cart.length; i++) {
                if (user.cart[i].product._id.equals(product.id)) {
                    isProductFound = true
                }
            }

            if (isProductFound) {
                let producttt = user.cart.find((i) => i.product._id.equals(product._id))
                producttt.quantity += 1
            } else {
                user.cart.push({ product: product._id, quantity: 1 })
            }

        }
        // In routes/user.js (add-to-cart route)
        user = await user.save();
        /* The .populate('cart.product') in your code tells 
        Mongoose to replace the product field in each cart item (which is just a Product ObjectId by default) 
        with the full Product document from your products collection.*/
        const populatedUser = await User.findById(user._id).populate('cart.product');
        res.json(populatedUser);
    } catch (e) {
        res.status(500).json({ addToCartError: e.message })
    }
})


userRouter.post('/api/remove-from-cart/:id', auth, async (req, res) => {
    try {
        const { id } = req.params // product id
        const product = await Product.findById(id)
        let user = await User.findById(req.user)


        for (let i = 0; i < user.cart.length; i++) {
            if (user.cart[i].product._id.equals(product.id)) {

                if (user.cart[i].quantity == 1) {
                    user.cart.splice(i, 1)
                } else {

                    user.cart[i].quantity -= 1;
                }

            }
        }




        // In routes/user.js (add-to-cart route)
        user = await user.save();
        /* The .populate('cart.product') in your code tells 
        Mongoose to replace the product field in each cart item (which is just a Product ObjectId by default) 
        with the full Product document from your products collection.*/
        const populatedUser = await User.findById(user._id).populate('cart.product');
        res.json(populatedUser);
    } catch (e) {
        res.status(500).json({ removeFromCartError: e.message })
    }
})


// save user address
userRouter.post('/api/save-user-address', auth, async (req, res) => {
    try {
        const { address } = req.body
        let user = await User.findById(req.user)
        user.address = address
        user = await user.save()
        res.json(user)
    } catch (e) {
        res.status(500).json({ saveUserAddressError: e.message })
    }
})

// order product
userRouter.post('/api/order', auth, async (req, res) => {
    try {
        const { cart, totalPrice, address } = req.body
        let products = [];
        let quantity = [];
        for (let i = 0; i < cart.length; i++) {
            let product = await Product.findById(cart[i].product._id);
            if (product.quantity >= cart[i].quantity) {
                product.quantity -= cart[i].quantity;
                products.push(product); // just the product document
                quantity.push(cart[i].quantity); // just the quantity
                await product.save();
            } else {
                return res.status(400).json({ msg: `${product.name} is out of stock!` });
            }
        }
        let order = new Order({
            products,    // array of Product documents
            quantity,    // array of integers
            totalPrice,
            address,
            userId: req.user,
            orderAt: new Date().getTime(),
        })

        // CLEAR THE USER'S CART IN THE DATABASE
        let user = await User.findById(req.user);
        user.cart = [];
        await user.save();

        order = await order.save()
        res.json(order)

    } catch (e) {
        res.status(500).json({ saveOrderError: e.message })
    }
})

// fetch orders
userRouter.get('/api/orders/me', auth, async (req, res) => {
    try {
        // const orders = await Order.find({ userId: req.user })
        const orders = await Order.find({ userId: req.user }).populate('products');
        res.json(orders)
    } catch (e) {
        res.status(500).json({ fetchOrdersError: e.message })
    }
})


module.exports = userRouter
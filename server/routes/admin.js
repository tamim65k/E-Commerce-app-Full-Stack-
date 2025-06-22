const express = require('express')
const adminRouter = express.Router()
const admin = require('../middlewares/admin')
const { Product } = require('../models/product')
const Order = require('../models/order')


// Add product
adminRouter.post('/admin/add-product', admin, async (req, res) => {
    try {
        const { name, description, quantity, price, category, images } = req.body

        let product = new Product({ // let allows to change instead of const
            name,
            description,
            images,
            quantity,
            price,
            category,
        })

        product = await product.save()
        res.json(product)
    } catch (e) {
        res.status(500).json({ addProductError: e.message })
    }
})

// /admin/get-products

adminRouter.get('/admin/get-products', admin, async (req, res) => {
    try {
        const products = await Product.find({})
        res.json(products)
    } catch (e) {
        res.status(500).json({ getProductError: e.message })
    }
})

// delete the products

adminRouter.post('/admin/delete-product', admin, async (req, res) => {
    try {
        const { id } = req.body
        let product = await Product.findByIdAndDelete(id)
        res.json(product)
    } catch (e) {
        res.status(500).json({ deleteProductError: e.message })
    }
})


adminRouter.get('/admin/get-orders', admin, async (req, res) => {
    try {
        const orders = await Order.find({}).populate('products')
        res.json(orders)
        // print(orders)
    } catch (e) {
        res.status(500).json({ getOrdersError: e.message })
    }
})

// create a post route for updating order status
adminRouter.post('/admin/change-order-status', admin, async (req, res) => {
    try {
        const { id, status } = req.body
        let order = await Order.findById(id)
        if (!order) {
            return res.status(404).json({ error: "Order not found" })
        }
        order.status = status
        await order.save()
        res.json(order)
    } catch (e) {
        res.status(500).json({ changeOrderStatusError: e.message })
    }
})


// get the total earnings - CORRECTED AND EFFICIENT VERSION
adminRouter.get('/admin/analytics', admin, async (req, res) => {
    try {
        const orders = await Order.find({}).populate('products');
        let totalEarnings = 0;

        // Calculate total earnings from the pre-calculated total price of each order
        for (let i = 0; i < orders.length; i++) {
            totalEarnings += orders[i].totalPrice;
        }

        // Calculate category-wise earnings
        let mobileEarnings = 0;
        let essentialEarnings = 0;
        let applianceEarnings = 0;
        let bookEarnings = 0;
        let fashionEarnings = 0;

        for (let i = 0; i < orders.length; i++) {
            for (let j = 0; j < orders[i].products.length; j++) {
                const product = orders[i].products[j];
                const quantity = orders[i].quantity[j];
                const earningForProduct = quantity * product.price;

                switch (product.category) {
                    case 'Mobiles':
                        mobileEarnings += earningForProduct;
                        break;
                    case 'Essentials':
                        essentialEarnings += earningForProduct;
                        break;
                    case 'Appliances':
                        applianceEarnings += earningForProduct;
                        break;
                    case 'Books':
                        bookEarnings += earningForProduct;
                        break;
                    case 'Fashion':
                        fashionEarnings += earningForProduct;
                        break;
                }
            }
        }

        let earnings = {
            totalEarnings,
            mobileEarnings,
            essentialEarnings,
            applianceEarnings,
            bookEarnings,
            fashionEarnings,
        };

        res.json(earnings);
    } catch (e) {
        res.status(500).json({ fetchAnlyticsError: e.message });
    }
})

async function fetchCategoryWiseProduct(category) {
    let earnings = 0

    let categoryOrders = await Order.find({
        'products.product.category': category,
    })

    for (let i = 0; i < categoryOrders.length; i++) {
        for (let j = 0; j < categoryOrders[i].products.length; j++) {
            earnings += categoryOrders[i].products[j].quantity * categoryOrders[i].products[j].price
        }
    }

    return earnings
}

module.exports = adminRouter
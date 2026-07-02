require('dotenv').config(); // ← à ajouter absolument !
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

// Define the payment controller functions
const createPayment = async (req, res) => {
    try {
        const { amount, customerEmail, customerName } = req.body;
        
        // Create a Stripe Checkout Session with customer information
        const session = await stripe.checkout.sessions.create({
            payment_method_types: ['card'],
            customer_email: customerEmail, // Ajouter l'email du client si disponible
            line_items: [
                {
                    price_data: {
                        currency: 'eur',
                        product_data: {
                            name: 'Services QuikDoc',
                            description: customerName ? `Client: ${customerName}` : undefined,
                        },
                        unit_amount: Math.round(amount * 100), // Stripe requires amount in cents
                    },
                    quantity: 1,
                },
            ],
            mode: 'payment',
            success_url: `${process.env.FRONTEND_URL || 'http://localhost:5173'}/payment-success?session_id={CHECKOUT_SESSION_ID}`,
            cancel_url: `${process.env.FRONTEND_URL || 'http://localhost:5173'}/payment-cancel`,
            // Ajouter des métadonnées pour stocker plus d'informations sur le client
            metadata: {
                user_id: req.user ? req.user.id : null,
                customer_name: customerName || 'Client non spécifié',
            },
        });

        res.json({
            success: true,
            checkoutUrl: session.url
        });
    } catch (error) {
        console.error('Stripe checkout error:', error);
        res.status(400).json({
            success: false,
            message: error.message
        });
    }
};

const getUserPayments = async (req, res) => {
    try {
        const userId = req.params.userId;
        // Get payments from Checkout Sessions instead of charges
        const paymentIntents = await stripe.paymentIntents.list({
            limit: 10,
            customer: userId
        });
        
        res.json({
            success: true,
            payments: paymentIntents.data
        });
    } catch (error) {
        console.error('Error fetching payment history:', error);
        res.status(400).json({
            success: false,
            message: error.message
        });
    }
};

// Verify the payment status using the session ID
const verifyPayment = async (req, res) => {
    try {
        const { sessionId } = req.params;
        
        const session = await stripe.checkout.sessions.retrieve(sessionId);
        
        if (session.payment_status === 'paid') {
            // Payment was successful
            res.json({
                success: true,
                paid: true,
                session: session
            });
        } else {
            // Payment is pending or failed
            res.json({
                success: true,
                paid: false,
                session: session
            });
        }
    } catch (error) {
        console.error('Error verifying payment:', error);
        res.status(400).json({
            success: false,
            message: error.message
        });
    }
};

module.exports = {
    createPayment,
    getUserPayments,
    verifyPayment
};

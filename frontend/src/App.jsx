import { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import './App.css';

function App() {
  const [cart, setCart] = useState(() => {
    const savedCart = localStorage.getItem('cart');
    return savedCart ? JSON.parse(savedCart) : [];
  });

  useEffect(() => {
    localStorage.setItem('cart', JSON.stringify(cart));
  }, [cart]);

  const addToCart = (product) => {
    setCart((prevCart) => [...prevCart, product]);
  };

  const removeFromCart = (productToRemove) => {
    setCart((prevCart) => prevCart.filter(item => item.name !== productToRemove.name));
  };

  return (
    <Router>
      <div className="app">
        {/* Header */}
        <header className="app-header">
          <h1>Database Shop</h1>
          <nav>
            <Link to="/">Home</Link>
            {/* Display Cart item count */}
            <Link to="/cart">Cart ({cart.length})</Link>
          </nav>
        </header>

        {/* Routes */}
        <Routes>
          <Route
            path="/"
            element={<HomePage addToCart={addToCart} cart={cart} />}
          />
          <Route
            path="/cart"
            element={<CartPage cart={cart} removeFromCart={removeFromCart} />}
          />
        </Routes>

        {/* Footer */}
        <footer>
          <p>&copy; 2024 Shop. All rights reserved</p>
        </footer>
      </div>
    </Router>
  );
}

function HomePage({ addToCart, cart }) {
  return (
    <main>
      <h2>Welcome to the Shop</h2>
      <p>Your one-stop shop for digital products!</p>
      <div className="product-grid">
        <ProductCard name="Visual Studio" price={150.00} addToCart={addToCart} cart={cart} />
        <ProductCard name="Power BI" price={200.00} addToCart={addToCart} cart={cart} />
        <ProductCard name="Adobe Photoshop" price={250.00} addToCart={addToCart} cart={cart} />
        <ProductCard name="Cyberpunk 2077" price={60.00} addToCart={addToCart} cart={cart} />
        <ProductCard name="Norton Security" price={50.00} addToCart={addToCart} cart={cart} />
        <ProductCard name="Microsoft Office" price={120.00} addToCart={addToCart} cart={cart} />
        <ProductCard name="MySQL Workbench" price={65.00} addToCart={addToCart} cart={cart} />
        <ProductCard name="AWS Cloud Storage" price={50.00} addToCart={addToCart} cart={cart} />
        <ProductCard name="Trello" price={10.00} addToCart={addToCart} cart={cart} />
        <ProductCard name="WinRAR" price={30.00} addToCart={addToCart} cart={cart} />
      </div>
    </main>
  );
}

function ProductCard({ name, price, addToCart, cart }) {
  const [addedToCart, setAddedToCart] = useState(false);

  const handleBuy = () => {
    addToCart({ name, price });
    setAddedToCart(true); // Mark the product as added to the cart
  };

  const isInCart = cart.some(item => item.name === name); // Check if the item is already in the cart

  return (
    <div className="product-card">
      <h3>{name}</h3>
      <p>${price.toFixed(2)}</p>
      <button onClick={handleBuy} disabled={isInCart}>
        {isInCart ? 'In Cart' : 'Add to Cart'}
      </button>
    </div>
  );
}

function CartPage({ cart, removeFromCart }) {
  const handleRemove = (itemToRemove) => {
    removeFromCart(itemToRemove);
  };

  // Calculate subtotal
  const subtotal = cart.reduce((total, item) => total + item.price, 0);
  const taxRate = 0.13;
  const taxes = subtotal * taxRate;
  const total = subtotal + taxes;

  return (
    <main className="cart-page">
      <h2>Your Cart</h2>
      {cart.length === 0 ? (
        <p className="empty-cart">Your cart is empty.</p>
      ) : (
        <div className="cart-container">
          <table className="cart-table">
            <thead>
              <tr>
                <th>Item</th>
                <th>Price</th>
              </tr>
            </thead>
            <tbody>
              {cart.map((item, index) => (
                <tr key={index}>
                  <td style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    {/* Item name */}
                    <span>{item.name}</span>
                    {/* Remove X button aligned to the right */}
                    <button
                      className="remove-button"
                      onClick={() => handleRemove(item)}
                      style={{
                        backgroundColor: 'transparent',
                        color: 'red',
                        border: 'none',
                        fontSize: '18px',
                        cursor: 'pointer',
                      }}
                    >
                      X
                    </button>
                  </td>
                  <td>${item.price.toFixed(2)}</td>
                </tr>
              ))}
            </tbody>
          </table>
          <div className="cart-summary">
            <p>Subtotal: ${subtotal.toFixed(2)}</p>
            <p>Taxes: ${taxes.toFixed(2)}</p>
            <p>Total: ${total.toFixed(2)}</p>
          </div>
        </div>
      )}
    </main>
  );
}



export default App;
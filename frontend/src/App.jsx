import { useState, useEffect } from "react";
import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom";
import "./App.css";

function App() {
  const [cart, setCart] = useState(() => {
    const savedCart = localStorage.getItem("cart");
    return savedCart ? JSON.parse(savedCart) : [];
  });

  // Save cart data to localStorage whenever it changes
  useEffect(() => {
    localStorage.setItem("cart", JSON.stringify(cart));
  }, [cart]);

  // Function to call the backend and add product to cart
  const addToCartBackend = async (product) => {
    try {
      // Log the payload to verify
      console.log("Sending to backend:", { productId: product.id, quantity: 1 });
  
      const response = await fetch("http://localhost:3001/api/cart", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          productId: product.id, 
          quantity: 1, 
          cartId: 20, 
        }),
      });
  
      if (!response.ok) { 
        const errorMessage = await response.text();
        throw new Error(`Backend error: ${response.status} - ${errorMessage}`);
      }
  
      console.log("Product successfully added to backend cart:", product);
    } catch (error) {
      console.error("Error adding product to backend cart:", error);
      throw error;
    }
  };
  
  
  
  

  // Frontend function to add product to local cart and trigger backend
  const addToCart = async (product) => {
    try {
      await addToCartBackend(product); // Wait for backend response
      setCart((prevCart) => [...prevCart, product]); // Update cart on success
    } catch (error) {
      console.error("Error syncing with backend:", error);
      alert("Failed to add product to cart. Please try again.");
    }
  };
  
  

  // Remove product from cart
  const removeFromCart = (productToRemove) => {
    setCart((prevCart) =>
      prevCart.filter((item) => item.name !== productToRemove.name)
    );
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

// HomePage displays product cards
function HomePage({ addToCart, cart }) {
  return (
    <main>
      <h2>Welcome to the Shop</h2>
      <p>Your one-stop shop for digital products!</p>
      <div className="product-grid">
        {/*  IDs for backend reference */}
        <ProductCard id={1} name="Visual Studio" price={150.0} addToCart={addToCart} cart={cart} />
        <ProductCard id={2} name="Power BI" price={200.0} addToCart={addToCart} cart={cart} />
        <ProductCard id={3} name="Adobe Photoshop" price={250.0} addToCart={addToCart} cart={cart} />
        <ProductCard id={4} name="Cyberpunk 2077" price={60.0} addToCart={addToCart} cart={cart} />
        <ProductCard id={5} name="Norton Security" price={50.0} addToCart={addToCart} cart={cart} />
        <ProductCard id={6} name="Microsoft Office" price={120.0} addToCart={addToCart} cart={cart} />
        <ProductCard id={7} name="MySQL Workbench" price={65.0} addToCart={addToCart} cart={cart} />
        <ProductCard id={8} name="AWS Cloud Storage" price={50.0} addToCart={addToCart} cart={cart} />
        <ProductCard id={9} name="Trello" price={10.0} addToCart={addToCart} cart={cart} />
        <ProductCard id={10} name="WinRAR" price={30.0} addToCart={addToCart} cart={cart} />
      </div>
    </main>
  );
}

// ProductCard component for each product
function ProductCard({ id, name, price, addToCart, cart }) {
  const [addedToCart, setAddedToCart] = useState(false);

  const handleBuy = () => {
    addToCart({ id, name, price });
    setAddedToCart(true); // Mark the product as added to the cart
  };

  const isInCart = cart.some((item) => item.id === id); // Check if the item is already in the cart

  return (
    <div className="product-card">
      <h3>{name}</h3>
      <p>${price.toFixed(2)}</p>
      <button onClick={handleBuy} disabled={isInCart}>
        {isInCart ? "In Cart" : "Add to Cart"}
      </button>
    </div>
  );
}

// CartPage to display and manage items in the cart
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
                  <td
                    style={{
                      display: "flex",
                      justifyContent: "space-between",
                      alignItems: "center",
                    }}
                  >
                    {/* Item name */}
                    <span>{item.name}</span>
                    {/* Remove X button aligned to the right */}
                    <button
                      className="remove-button"
                      onClick={() => handleRemove(item)}
                      style={{
                        backgroundColor: "transparent",
                        color: "red",
                        border: "none",
                        fontSize: "18px",
                        cursor: "pointer",
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

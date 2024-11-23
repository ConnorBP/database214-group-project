import {useState} from 'react';
import './App.css';

function App() {
  return (
  <div className="app">
    {/* Header */}
    <header className="app-header">
      <h1>Database Shop</h1>
      <nav>
        <a href="#">Home</a>
        <a href="#">Products</a>
        <a href="#">Cart</a>
      </nav>
    </header>

    {/* Main */}
    <main>
      <h2>Welcome to the Shop</h2>
      <p>Your one-stop shop for digital products!</p>
      <div className="product-grid">
        <ProductCard className="product-title" name="Digital Planner" price="19.99" />
        <ProductCard className="product-title" name="eBook" price="4.99" />
        <ProductCard className="product-title" name="Stock Photo Pack" price="9.99" />
      </div>
    </main>
      
      {/* Footer */}
      <footer>
        <p>&copy; 2021 Shop. All rights reserved</p>
      </footer>
  </div>
  );
}

// Product card stuff
function ProductCard({name, price}){
  const [purchased, setPurchased] = useState(false);

  const handleBuy = () => { 
    alert('Thank you for your purchase!');
    setPurchased(true);
  };

  return (
    <div className="product-card">
      <h3>{name}</h3>
      <p>${price}</p>
      <button onClick={handleBuy} disabled={purchased}>
        {purchased ? 'Purchased' : 'Buy'}
      </button>
    </div>

  )
}

export default App;
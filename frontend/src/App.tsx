import { BrowserRouter as Router, Route, Routes } from 'react-router-dom'
import Navbar from './components/Nav'
import Heropage from './components/Hero'
import Metrics from './components/Metrics'
import Content from './components/Content'
import Footer from './components/Footer'
import Dapp from './DApp/page'

function App() {
  return (
    <Router>
      <Routes>
        <Route
          path="/"
          element={
            <div className="bg-[#030B1E] h-screen bg-hero-semi-circle">
              <Navbar />
              <Heropage />
              <Metrics />
              <div className="bg-[#030B1E]">
                <Content />
              </div>
              <Footer />
            </div>
          }
        />

        <Route path="/DApp" element={<Dapp />} />
      </Routes>
    </Router>
  )
}

export default App

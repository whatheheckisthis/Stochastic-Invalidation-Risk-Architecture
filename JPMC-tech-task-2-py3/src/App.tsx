import React from 'react';
import './App.css';

const App: React.FC = () => {
  return (
    <div className="report-root">
      <div className="cover">
        <div className="cover-label">Technical Case Study · Distressed Asset Risk Modeling</div>
        <h1>
          Stochastic Invalidation
          <br />
          &amp; <em>Risk Architecture</em>
        </h1>
        <div className="cover-sub">Black Box Recovery Probability Engine — Institutional Grade</div>
        <div className="cover-meta">
          <span><b>Tooling</b>R · ggplot2 · Monte Carlo</span>
          <span><b>Engine Mode</b>Internal Data (Fail-Safe)</span>
          <span><b>Simulations</b>10,000 per Asset × Scenario</span>
          <span><b>Portfolio</b>10 Distressed Assets · 5 Scenarios</span>
        </div>
      </div>

      <section className="section">
        <div className="section-header">
          <span className="section-num">01</span>
          <span className="section-title">Problem Statement</span>
        </div>

        <div className="statement">
          In high-stakes finance, waiting for API data during a crisis is a fatal flaw. A risk engine that depends on live connectivity will go dark precisely when it is needed most.
        </div>

        <p>
          During Black Swan events — systemic dislocations, exchange halts, counterparty failures — the standard assumption of continuous data availability collapses. Fund managers operating distressed asset portfolios cannot afford a risk model that silently fails at the moment of peak exposure.
        </p>

        <p>
          This engine was engineered around a single architectural constraint: <strong>it must run 100% of the time, regardless of connectivity.</strong> All market parameters, asset metadata, and stochastic inputs are hard-coded as internal data structures. There is no API call, no live feed, no external dependency that can cause a runtime failure.
        </p>
      </section>

      <section className="section">
        <div className="section-header">
          <span className="section-num">02</span>
          <span className="section-title">Methodology</span>
        </div>

        <div className="method-grid">
          <div className="method-card">
            <div className="card-label">Tooling</div>
            <div className="card-title">R · ggplot2 · Base Stats</div>
            <p>Developed in R using base statistics and ggplot2 for visualization. No external database, no live API dependency. Maximum runtime stability in degraded environments.</p>
          </div>
          <div className="method-card">
            <div className="card-label">Simulation Logic</div>
            <div className="card-title">Monte Carlo · Z-Score Alerting</div>
            <p>10,000 stochastic draws per asset per scenario via rnorm(). Z-score distance-from-mean against the institutional floor triggers automated High Risk flags.</p>
          </div>
          <div className="method-card">
            <div className="card-label">Invalidation Logic</div>
            <div className="card-title">Net Recovery = Gross − Carry</div>
            <p>Each simulation computes net recovery after annualised carry cost. When net recovery crosses zero, cost of capital exceeds projected recovery — the Invalidation Point.</p>
          </div>
        </div>

        <p>
          The engine uses a <strong>Z-score distance-from-mean</strong> calculation as its alert trigger. When the mean simulated net recovery falls below the institutional floor (net = 0, equivalent to gross recovery of 1.0×), the asset is flagged. The magnitude of that distance, weighted by scenario volatility, produces the Risk/Stress Score.
        </p>

        <div className="formula">
          Net Recovery = Gross Recovery − (CoC × Horizon/365)<br />
          Z-Score (Floor) = (Mean_Net − 0) / σ_Net<br />
          Risk/Stress Score = max(0, −Z × 100) + (vol_mult − 1) × 25<br />
          Invalidation Pt = Net Recovery {'<'} 0 → SELL signal
        </div>
      </section>

      <section className="section">
        <div className="section-header">
          <span className="section-num">03</span>
          <span className="section-title">Scenario Architecture</span>
        </div>

        <table className="scenario-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Scenario</th>
              <th>Rate Shock</th>
              <th>Horizon Multiplier</th>
              <th>Vol Multiplier</th>
              <th>Recovery Haircut</th>
              <th>Stress Thesis</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td><span className="sc-tag">S1</span></td>
              <td><strong>Baseline</strong></td>
              <td>+0 bps</td>
              <td>1.0×</td>
              <td>1.0×</td>
              <td>—</td>
              <td>Standard market conditions. Benchmark recovery floor.</td>
            </tr>
            <tr>
              <td><span className="sc-tag">S2</span></td>
              <td><strong>Rate Shock</strong></td>
              <td>+200 bps</td>
              <td>1.15×</td>
              <td>1.3×</td>
              <td>−7%</td>
              <td>Sudden 200bps+ rate spike compresses recoveries and extends exit.</td>
            </tr>
            <tr>
              <td><span className="sc-tag">S3</span></td>
              <td><strong>Liquidity Trap</strong></td>
              <td>+100 bps</td>
              <td>1.8×</td>
              <td>1.2×</td>
              <td>−10%</td>
              <td>Exit horizons extend 180→450 days. Carry cost accumulation is primary risk.</td>
            </tr>
            <tr>
              <td><span className="sc-tag">S4</span></td>
              <td><strong>Variance Error</strong></td>
              <td>+50 bps</td>
              <td>1.1×</td>
              <td>1.9×</td>
              <td>−5%</td>
              <td>High-volatility bullpen errors (15–20% margin). Wide σ bands, SELL signals uncertain.</td>
            </tr>
            <tr>
              <td><span className="sc-tag bs">S5</span></td>
              <td><strong>Black Swan</strong></td>
              <td>+350 bps</td>
              <td>2.2×</td>
              <td>2.5×</td>
              <td>−22%</td>
              <td>Combined systemic failure. All stress variables trigger simultaneously.</td>
            </tr>
          </tbody>
        </table>
      </section>

      <section className="section">
        <div className="section-header">
          <span className="section-num">04</span>
          <span className="section-title">Key Results</span>
        </div>

        <p>Mean net recovery and SELL signal counts across all five scenarios. The portfolio holds through S1–S4 but Black Swan (S5) triggers three SELL signals and one WATCH — the Ruin Threshold breach.</p>

        <div className="results-grid">
          <div className="res-card">
            <div className="sc-name">S1 · Baseline</div>
            <div className="rec-val rec-green">52.1%</div>
            <div className="rec-label">Mean Net Recovery</div>
            <div className="sell-count none">0 SELL · 0 WATCH</div>
          </div>
          <div className="res-card">
            <div className="sc-name">S2 · Rate Shock</div>
            <div className="rec-val rec-green">42.1%</div>
            <div className="rec-label">Mean Net Recovery</div>
            <div className="sell-count none">0 SELL · 0 WATCH</div>
          </div>
          <div className="res-card">
            <div className="sc-name">S3 · Liq. Trap</div>
            <div className="rec-val rec-green">34.8%</div>
            <div className="rec-label">Mean Net Recovery</div>
            <div className="sell-count none">0 SELL · 0 WATCH</div>
          </div>
          <div className="res-card">
            <div className="sc-name">S4 · Variance</div>
            <div className="rec-val rec-green">45.6%</div>
            <div className="rec-label">Mean Net Recovery</div>
            <div className="sell-count none">0 SELL · 0 WATCH</div>
          </div>
          <div className="res-card">
            <div className="sc-name">S5 · Black Swan</div>
            <div className="rec-val rec-red">15.2%</div>
            <div className="rec-label">Mean Net Recovery</div>
            <div className="sell-count crit">3 SELL · 1 WATCH</div>
          </div>
        </div>
      </section>

      <div className="footer">
        <span>Stochastic Invalidation &amp; Risk Architecture · Black Box Engine v1.0</span>
        <span>R · ggplot2 · Monte Carlo · Internal Data Mode · N=10,000</span>
      </div>
    </div>
  );
};

export default App;

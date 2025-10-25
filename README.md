# ErgoAI Tariff Reasoner

**Logic-based modeling of import tax policies using ErgoAI**

---

## 🧠 Overview
This project uses **ErgoAI**, a declarative knowledge representation and reasoning system, to model how import duties are determined.  
The goal is to demonstrate that complex, exception-filled tariff rules can be expressed and computed in a **transparent, explainable, and easily updatable** way — without hard-coding logic in procedural software.

Traditional systems embed tax logic directly in code, making them brittle when laws change.  
ErgoAI provides a way to encode these rules as *knowledge* rather than *instructions*.

---

## ⚙️ Core Objectives
1. **Design a knowledge schema** that represents:
   - Tariff codes (HTS)
   - Countries of origin / import
   - Effective dates
   - Trade agreements and exemptions  
2. **Implement core reasoning rules** in `ergo/base_rules.ergo` that:
   - Match shipments to applicable tariff codes  
   - Apply base duty rates and exceptions  
   - Explain the reasoning chain in natural language  
3. **Demonstrate the system** on sample shipment data:
   - Input: HTS code, origin, declared value, date  
   - Output: Calculated duty and explanation of why it applies  

---

## 🧩 Project Structure
```text
app/        Python entrypoints for running ErgoAI queries and demos
ergo/       ErgoAI knowledge base (schema + reasoning rules)
rag/        [Optional] Future extension for retrieving new tariff policies
data/       Example datasets and sample shipment facts
docs/       Research documentation, architecture diagrams, and reports

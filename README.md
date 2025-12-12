# llm-logic-research
Research project integrating symbolic logic (Prolog) with LLMs to reduce hallucinations. 
# LLM Logic Research: Symbolic Reasoning Integration

Research project integrating symbolic logic (Prolog) with Large Language Models to enhance logical reasoning and reduce hallucinations.

**Author:** Tanvi Reddy Pothireddy  
**Affiliation:** Student Research Intern @ UCSC

## 📋 Overview

This research demonstrates that integrating Prolog-based symbolic reasoning with LLMs significantly improves logical accuracy and consistency. The system achieved:
- **Academic Domain:** 100% accuracy (simple), 96.67% (complex), 93.33% (multi-step)
- **Business Domain:** 100% accuracy (simple), 90% (complex), 86.67% (multi-step)

## 📁 Repository Structure
```
llm-logic-research/
├── knowledge-bases/          # Prolog knowledge bases
│   ├── academic_relations.pl
│   └── business_operations.pl
├── queries/                  # Query sets for testing
│   ├── academic_queries_15.txt
│   ├── academic_queries_45.txt
│   ├── academic_queries_90.txt
│   ├── business_queries_15.txt
│   ├── business_queries_45.txt
│   └── business_queries_90.txt
├── src/                      # Source code
│   └── baseline_experiment.py
├── data/                     # Experimental results
│   └── results/
├── docs/                     # Documentation
│   └── research_paper.pdf
├── requirements.txt          # Python dependencies
├── .gitignore
├── LICENSE
└── README.md
```

## 🚀 Setup Instructions

### Prerequisites

Before running the experiments, ensure you have:
- **Python 3.8+** installed
- **SWI-Prolog** installed ([Download here](https://www.swi-prolog.org/download/stable))
- **OpenAI API key** (for GPT-4 translation layer)

### Step 1: Install SWI-Prolog

**macOS:**
```bash
brew install swi-prolog
```

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install swi-prolog
```

**Windows:**
Download and install from [swi-prolog.org](https://www.swi-prolog.org/download/stable)

### Step 2: Clone the Repository
```bash
git clone https://github.com/tanvi-sai/llm-logic-research.git
cd llm-logic-research
```

### Step 3: Install Python Dependencies
```bash
pip install -r requirements.txt
```

**Required packages:**
- `openai` - OpenAI API for natural language translation
- `pyswip` - Python-Prolog integration library

### Step 4: Set Up OpenAI API Key

The OpenAI API is used to translate natural language queries into Prolog syntax.

1. Get your API key from the [OpenAI Platform](https://platform.openai.com/)
2. Create a `.env` file in the root directory:
```bash
OPENAI_API_KEY=your_api_key_here
```

**Note:** Never commit your API key to the repository. The `.gitignore` file is configured to exclude `.env` files.

### Step 5: Verify Installation

Test your SWI-Prolog installation:
```bash
swipl --version
```

Test PySwip integration:
```python
python -c "from pyswip import Prolog; print('PySwip installed successfully')"
```

## 🧪 Running Experiments

### Baseline Experiment

The baseline experiment demonstrates basic natural language to Prolog translation:
```bash
python src/baseline_experiment.py
```

**What it does:**
- Translates a simple natural language query into Prolog
- Executes the Prolog code
- Returns symbolic reasoning results

**Example output:**
```
Query: "Which birds cannot fly?"
Prolog: bird(penguin). cannot_fly(penguin).
Result: {X: penguin}
```

### Testing with Knowledge Bases

#### Academic Relations Domain

Test queries against the academic prerequisites knowledge base:
```bash
# Load the knowledge base in SWI-Prolog
swipl knowledge-bases/academic_relations.pl
```

**Example queries to try:**
```prolog
% Simple queries
?- prerequisite(algebra_1, algebra_2).
% Expected: true

?- completed(sarah, precalculus).
% Expected: true

?- department(calculus_1, X).
% Expected: X = mathematics

% Complex queries
?- eligible(sarah, calculus_2).
% Expected: false (currently enrolled in Calculus 1)

?- advanced_student(james).
% Expected: true

% Multi-step queries
?- prerequisite_chain(algebra_1, calculus_2, Path).
% Expected: Path = [algebra_1, algebra_2, precalculus, calculus_1, calculus_2]
```

#### Business Operations Domain

Test queries against the business operations knowledge base:
```bash
swipl knowledge-bases/business_operations.pl
```

**Example queries to try:**
```prolog
% Simple queries
?- purchased(alice, laptop).
% Expected: true

?- loyalty_member(bob, gold).
% Expected: false

?- category(smartphone, X).
% Expected: X = electronics

% Complex queries
?- high_value_customer(alice).
% Expected: true

?- cross_sell_opportunity(alice, X).
% Expected: X = external_monitor

% Multi-step queries
?- high_value_customer(X), high_spender(X).
% Expected: X = alice; X = carol
```

### Running Full Test Suites

Use the provided query files to run comprehensive tests:

**15 Queries (5 per complexity level):**
```bash
cat queries/academic_queries_15.txt | xargs -I {} swipl -g "{}" -t halt knowledge-bases/academic_relations.pl
```

**45 Queries (15 per complexity level):**
```bash
cat queries/academic_queries_45.txt | xargs -I {} swipl -g "{}" -t halt knowledge-bases/academic_relations.pl
```

**90 Queries (30 per complexity level):**
```bash
cat queries/academic_queries_90.txt | xargs -I {} swipl -g "{}" -t halt knowledge-bases/academic_relations.pl
```

## 📊 Understanding the Knowledge Bases

### Academic Relations KB

Models course prerequisites, student enrollments, and academic structures.

**Key facts:**
- `prerequisite(Course1, Course2)` - Course1 is required before Course2
- `completed(Student, Course)` - Student has finished Course
- `enrolled(Student, Course)` - Student is currently taking Course
- `department(Course, Dept)` - Course belongs to Department
- `difficulty(Course, Level)` - Course difficulty (introductory/intermediate/advanced)

**Key rules:**
- `eligible(Student, Course)` - Student can enroll in Course
- `advanced_student(Student)` - Student has completed advanced courses
- `peers(Student1, Student2)` - Students share a course

### Business Operations KB

Models customer behavior, product relationships, and business rules.

**Key facts:**
- `purchased(Customer, Product)` - Customer bought Product
- `loyalty_member(Customer, Tier)` - Customer loyalty status
- `category(Product, Category)` - Product category
- `compatible(Product1, Product2)` - Products work together
- `in_stock(Product)` / `out_of_stock(Product)` - Inventory status

**Key rules:**
- `high_value_customer(Customer)` - Gold loyalty members
- `cross_sell_opportunity(Customer, Product)` - Upsell recommendations
- `vip_customer(Customer)` - Gold member AND high spender

## 📈 Expected Results

Based on the research paper, the symbolic reasoning system outperforms baseline LLMs:

| Domain | Complexity | Prolog | ChatGPT | Gemini | Anthropic |
|--------|-----------|--------|---------|---------|-----------|
| **Academic** | Simple | 100% | 100% | 100% | 100% |
| | Complex | 96.67% | 88% | 96% | 98% |
| | Multi-step | 93.33% | 78% | 88% | 88% |
| **Business** | Simple | 100% | 98% | 100% | 100% |
| | Complex | 90% | 78% | 76% | 60% |
| | Multi-step | 86.67% | 72% | 60% | 62% |

## 🔧 Troubleshooting

### PySwip Installation Issues

If you encounter errors with PySwip:
```bash
# macOS: Install Xcode Command Line Tools first
xcode-select --install

# Linux: Install build essentials
sudo apt-get install build-essential

# Then reinstall PySwip
pip install --upgrade pyswip
```

### SWI-Prolog Path Issues

Ensure SWI-Prolog is in your system PATH:
```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="/usr/local/bin:$PATH"
```

### OpenAI API Errors

- Verify your API key is correct
- Check your OpenAI account has available credits
- Ensure you're not exceeding rate limits

## 📄 Citation

If you use this code in your research, please cite:
```bibtex
@article{pothireddy2025symbolic,
  title={Enhancing Logical Reasoning in Large Language Models through Symbolic Logic Integration to Reduce Hallucinated Outputs},
  author={Pothireddy, Tanvi Reddy},
  year={2025},
  institution={Student Research Intern}
}
```

## 📧 Contact & Support

**For questions or issues:**
- Open an issue in this repository
- Email: tanvi@saimail.com

**Research supervised by:**
Dr. Leilani Gilpin
lgilpin @ ucsc.edu

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- OpenAI for GPT-4 API
- SWI-Prolog development team
- LangChain and LangGraph frameworks

## 📚 Additional Resources

- [SWI-Prolog Documentation](https://www.swi-prolog.org/pldoc/doc_for?object=manual)
- [OpenAI API Documentation](https://platform.openai.com/docs/overview)
- [PySwip Documentation](https://github.com/yuce/pyswip)

---

**Last Updated:** December 2025

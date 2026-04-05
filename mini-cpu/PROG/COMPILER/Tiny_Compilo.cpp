#include <bits/stdc++.h>
using namespace std;

string zeros = "00000000";

int main() {

    regex const_def(R"(@(\w+)\s*=\s*(\d+|0x[0-9A-Fa-f]+))");
    regex label_def(R"(@(\w+):)");
    regex sta_instr(R"(\s*STA\s+@(\w+))");
    regex jcc_instr(R"(\s*JCC\(@(\w+)\))");
    regex jmp_instr(R"(\s*JMP\(@(\w+)\))");
    regex jce_instr(R"(\s*JCE\(@(\w+)\))");
    regex jcn_instr(R"(\s*JCN\(@(\w+)\))");

    regex alu_instr(R"(\s*ACCU\s*=\s*ACCU\s+(NOR|ADD|SUB|AND|OR|XOR)\s+mem\[@(\w+)\])");
    regex unary_instr(R"(\s*ACCU\s*=\s*(NOT|CLR)\s+ACCU)");
    regex mov_instr(R"(\s*ACCU\s*=\s*mem\[@(\w+)\])");

    map<string, string> mem_reg;
    int PC = 0;

    ifstream file("asm.txt");
    vector<string> instr_set;
    string instr;
    smatch match;

    while (getline(file, instr)) {
        instr = regex_replace(instr, regex(";.*$"), "");
        instr = regex_replace(instr, regex("^\\s+|\\s+$"), "");

        if (instr.empty())
            continue;

        else if (regex_match(instr, match, const_def)) {
            string name = match[1].str();
            string val_str = match[2].str();
            int value = (val_str.substr(0,2) == "0x") ? stoi(val_str, nullptr, 16) : stoi(val_str);
            mem_reg[name] = bitset<6>(value).to_string();
        }

        else if (regex_match(instr, match, label_def)) {
            string name = match[1].str();
            mem_reg[name] = bitset<6>(PC).to_string();
        }

        else {
            instr_set.push_back(instr);
            PC++;
        }
    }

    PC = 0;

    while (PC < instr_set.size()) {
        instr = instr_set[PC];

        if (regex_match(instr, match, sta_instr)) {
            cout << "1000" << zeros << mem_reg[match[1].str()] << endl;
        }

        else if (regex_match(instr, match, jmp_instr)) {
            cout << "1001" << zeros << mem_reg[match[1].str()] << endl;
        }

        else if (regex_match(instr, match, jcc_instr)) {
            cout << "1100" << zeros << mem_reg[match[1].str()] << endl;
        }

        else if (regex_match(instr, match, jce_instr)) {
            cout << "1010" << zeros << mem_reg[match[1].str()] << endl;
        }

        else if (regex_match(instr, match, jcn_instr)) {
            cout << "1011" << zeros << mem_reg[match[1].str()] << endl;
        }

        else if (regex_match(instr, match, alu_instr)) {
            string op = match[1].str();
            string addr = mem_reg[match[2].str()];
            string codeop;

            if (op == "NOR") codeop = "0000";
            else if (op == "ADD") codeop = "0100";
            else if (op == "SUB") codeop = "0101";
            else if (op == "AND") codeop = "0110";
            else if (op == "OR") codeop = "0111";
            else if (op == "XOR") codeop = "1000";

            cout << codeop << zeros << addr << endl;
        }

        else if (regex_match(instr, match, unary_instr)) {
            string op = match[1].str();
            string codeop = (op == "NOT") ? "0011" : "1111";
            cout << codeop << zeros << "000000" << endl;
        }

        else if (regex_match(instr, match, mov_instr)) {
            cout << "1010" << zeros << mem_reg[match[1].str()] << endl;
        }

        else {
            cout << "ERROR" << endl;
        }

        PC++;
    }

    return 0;
}
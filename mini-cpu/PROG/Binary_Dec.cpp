#include <bits/stdc++.h>
using namespace std; 

string dec_to_hex(int n){
    if(n == 0)
        return "\\x00";
    int tmp = n; 
    string res = ""; 
    while(tmp){
        int md = tmp % 16; 
        tmp /= 16;
        if(md < 10){
            res += to_string(md);
        }
        else if(md == 10)
            res += 'A'; 
        else if(md == 11)
            res += 'B'; 
        else if(md == 12)
            res += 'C'; 
        else if(md == 13)
            res += 'D'; 
        else if(md == 14)
            res += 'E';
        else
            res += 'F';
    }
    reverse(res.begin(), res.end()); 
    if(res.size() == 1)
        return "\\x0" + res;
    else
        return "\\x" + res;
}

int main(){
	FILE *bin, *dec, *hex; 
	bin = fopen("prime_verif.txt", "r");
    // dec = fopen("prime_dec.txt", "w"); 
    hex = fopen("prime_hex.hex", "w"); 
	if(!bin){
        fclose(bin);
        exit(1); 
    }
    char s[17];
    string s_hex;
   	while(fscanf(bin, "%16s" , &s) == 1){
        int dec_conv = stoi(s , nullptr , 2);
        s_hex = s;  
        //string w_dec = to_string(dec_conv);

        string f_bits = s_hex.substr(0,8); 
        string ff_bits = s_hex.substr(8); 

        int conv_hex_a = stoi(f_bits , nullptr , 2);
        int conv_hex_b = stoi(ff_bits , nullptr , 2);

        string hex_w_a = dec_to_hex(conv_hex_a);
        string hex_w_b = dec_to_hex(conv_hex_b);

        char a[4], b[4];
        int index = 0;
        for (char c : hex_w_a)
            a[index++] = c; 
        index = 0; 
        for (char c : hex_w_b)
            b[index++] = c; 
        //cout << s << " " << f_bits << " " << ff_bits << endl;
        cout << hex_w_b << endl << hex_w_a << endl;
        //fprintf(dec, "%d\n", dec_conv);
        fprintf(hex, "%s\n", hex_w_b.c_str());
        fprintf(hex, "%s\n", hex_w_a.c_str());

        //cout 
   	}
    //fclose(dec); 
    fclose(bin);
}
